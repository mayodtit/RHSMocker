class MessageTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  FIRST_MESSAGE_PRIORITY = 14
  NTH_MESSAGE_PRIORITY = 13
  NEEDS_RESPONSE_PRIORITY = 12
  AFTER_HOURS_MESSAGE_PRIORITY = 11
  INACTIVE_CONVERSATION_PRIORITY = 10
  ACTIVE_CONVERSATION_PRIORITY = 9

  belongs_to :consult
  belongs_to :message, inverse_of: :message_task

  attr_accessible :consult, :consult_id, :message, :message_id

  validates :consult, :message, presence: true
  validate :one_open_per_consult, if: :open?

  after_commit :update_member_service_states!

  delegate :subject, to: :consult

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

  private

  def default_queue
    :hcc
  end

  def one_open_per_consult
    if open_message_tasks_for_consult?
      errors.add(:consult_id, "open MessageTask already exists for Consult #{consult_id}")
    end
  end

  def open_message_tasks_for_consult?
    search_scope = self.class.open.where(consult_id: consult_id)
    search_scope = search_scope.where('id != ?', id) if id
    search_scope.any?
  end

  def set_defaults
    self.consult ||= message.try(:consult)
    self.member ||= consult.try(:initiator)

    unless role.try(:on_call?)
      self.owner ||= consult.try(:initiator).try(:pha)
      self.assignor = Member.robot
      self.assigned_at = Time.now
    end

    self.priority = if role.try(:on_call?) && message.try(:first_message_from_user_in_consult?)
                      FIRST_MESSAGE_PRIORITY
                    elsif role.try(:on_call?)
                      NTH_MESSAGE_PRIORITY
                    else
                      AFTER_HOURS_MESSAGE_PRIORITY
                    end

    super
  end

  def update_member_service_states!
    return if unclaimed? || claimed?
    transaction do
      member.services.where(state: :draft).each do |service|
        service.auto_transition!
      end
    end
  end
end
