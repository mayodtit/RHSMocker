class MessageTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  FIRST_MESSAGE_PRIORITY = 14
  NTH_MESSAGE_PRIORITY = 13
  NEEDS_RESPONSE_PRIORITY = 12
  AFTER_HOURS_MESSAGE_PRIORITY = 11
  INACTIVE_CONVERSATION_PRIORITY = 10
  ACTIVE_CONVERSATION_PRIORITY = 9

  belongs_to :consult
  belongs_to :message
  delegate :subject, to: :consult

  attr_accessible :consult, :consult_id, :message, :message_id

  validates :consult_id, presence: true
  validates :consult, presence: true, if: lambda { |t| t.consult_id }
  validates :message, presence: true, if: lambda { |t| t.message_id }
  validate :one_open_per_consult

  before_validation :set_consult, on: :create
  before_validation :set_owner, on: :create
  before_validation :set_member, on: :create
  before_validation :set_priority, on: :create

  def default_queue
    :hcc
  end

  def set_consult
    if consult.nil? && message.present?
      self.consult_id = message.consult_id
    end
  end

  def set_member
    self.member = consult.initiator if consult
  end

  def self.create_if_only_opened_for_consult!(consult, message = nil)
    if (!message || message.user == consult.initiator) && open.where(consult_id: consult.id).count == 0
      due_at = message ? message.created_at : consult.created_at
      create!(title: 'Inbound Message',
              consult: consult,
              message: message,
              creator: Member.robot,
              due_at: due_at)
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
    if role.on_call?
      self.priority = NTH_MESSAGE_PRIORITY
      if message_id.nil? || consult.messages.where('user_id = ? AND created_at < ?', message.user.id, message.created_at).count == 0
        self.priority = FIRST_MESSAGE_PRIORITY
      end
    else
      self.priority = AFTER_HOURS_MESSAGE_PRIORITY
    end
  end

  def set_owner
    if !Metadata.triage_off_hours_message? && !role.on_call? && consult.initiator && self.owner.nil?
      self.owner = consult.initiator.pha
      self.assignor = Member.robot
      self.assigned_at = Time.now
    end
  end
end
