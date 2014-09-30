class MessageTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  FIRST_MESSAGE_PRIORITY = 13
  NTH_MESSAGE_PRIORITY = 12
  ACTIVE_CONVERSATION_PRIORITY = 11
  INACTIVE_CONVERSATION_PRIORITY = 10

  belongs_to :consult
  belongs_to :message
  has_one :member, through: :consult, source: :initiator
  delegate :subject, to: :consult

  attr_accessible :consult, :consult_id, :message, :message_id

  validates :consult_id, presence: true
  validates :consult, presence: true, if: lambda { |t| t.consult_id }
  validates :message, presence: true, if: lambda { |t| t.message_id }
  validate :one_open_per_consult

  before_validation :set_consult, on: :create

  def set_consult
    if consult.nil? && message.present?
      self.consult_id = message.consult_id
    end
  end

  def self.create_if_only_opened_for_consult!(consult, message = nil)
    if (!message || message.user == consult.initiator) && open.where(consult_id: consult.id).count == 0
      due_at = message ? message.created_at : consult.created_at
      create!(title: 'Inbound Message', consult: consult, message: message, creator: Member.robot, due_at: due_at)
    end
  end

  def one_open_per_consult
    return unless open?
    task = self.class.open.where(consult_id: consult_id).first
    if task && task.id != id
      errors.add(:consult_id, "open MessageTask already exists for Consult #{consult_id}")
    end
  end

  def set_priority
    self.priority = NTH_MESSAGE_PRIORITY
    if message_id.nil? || consult.messages.where('user_id = ? AND created_at < ?', message.user.id, message.created_at).count == 0
      self.priority = FIRST_MESSAGE_PRIORITY
    end
  end
end