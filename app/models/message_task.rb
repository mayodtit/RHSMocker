class MessageTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :consult
  belongs_to :message

  delegate :subject, to: :consult

  attr_accessible :consult, :consult_id, :message, :message_id

  validates :consult_id, presence: true
  validates :consult, presence: true, if: lambda { |t| t.consult_id }
  validates :message, presence: true, if: lambda { |t| t.message_id }
  validate :one_open_per_consult

  before_validation :set_consult, on: :create

  def member
    consult && consult.initiator
  end

  def set_consult
    if consult.nil? && message.present?
      self.consult_id = message.consult_id
    end
  end

  def self.create_if_only_opened_for_consult!(consult, message = nil)
    if MessageTask.open.where(consult_id: consult.id).count == 0
      due_at = message ? message.created_at : consult.created_at
      self.create!(title: consult.title, consult: consult, message: message, creator: Member.robot, due_at: due_at)
    end
  end

  def one_open_per_consult
    return unless open?
    task = MessageTask.open.where(consult_id: consult_id).first
    if task && task.id != id
      errors.add(:consult_id, "Cannot be 'message' for consult #{consult_id} when another uncompleted 'message' task exists")
    end
  end
end