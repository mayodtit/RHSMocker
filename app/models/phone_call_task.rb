class PhoneCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :phone_call, inverse_of: :phone_call_task

  attr_accessible :phone_call_id, :phone_call

  validates :phone_call, presence: true
  validate :one_open_per_phone_call, if: :open?
  validate :one_claimed_per_owner

  delegate :consult, to: :phone_call

  def self.create_if_only_opened_for_phone_call!(phone_call)
    if phone_call.to_role.on_call? && open.where(phone_call_id: phone_call.id).count == 0
      create!(
        title: 'Inbound Phone Call',
        phone_call: phone_call,
        creator: Member.robot,
        due_at: phone_call.created_at
      )
    end
  end

  def notify
    return unless for_pha?

    super

    if id_changed? || owner_id_changed?
      if unassigned?
        Role.pha.users.where(on_call: true).each do |m|
          TwilioModule.message m.text_phone_number, 'ALERT: Inbound phone call needs triage'
        end
      elsif assignor_id != owner_id
        TwilioModule.message owner.text_phone_number, 'ALERT: Inbound phone call assigned to you'
      end
    end
  end

  private

  def default_queue
    if (role && for_nurse?) || phone_call.to_nurse?
      :nurse
    else
      :hcc
    end
  end

  def set_defaults
    self.member ||= phone_call.try(:user)
    self.role ||= phone_call.try(:to_role)
    self.priority ||= 15
    super
  end

  def one_open_per_phone_call
    if open_task_for_phone_call?
      errors.add(:phone_call_id, "open PhoneCallTask already exists for #{phone_call_id}")
    end
  end

  def open_task_for_phone_call?
    search_scope = self.class.open.where(phone_call_id: phone_call_id)
    search_scope = search_scope.where('id != ?', id) if id
    search_scope.any?
  end

  def one_claimed_per_owner
    if claimed?
      task = self.class.find_by_owner_id_and_state(owner_id, :claimed)
      if task && task.id != id
        errors.add(:state, "cannot claim more than one phone call task.")
      end
    end
  end

  state_machine :initial => :unclaimed do
    before_transition any => :unclaimed do |task|
      task.phone_call.update_attributes!(state_event: :unclaim)
    end

    before_transition any => :claimed do |task|
      if !task.phone_call.claimed?
        task.phone_call.update_attributes!(state_event: :claim, claimer: task.owner)
      end
    end

    before_transition any => :completed do |task|
      if task.phone_call.in_progress?
        task.phone_call.update_attributes!(state_event: :end, ender: task.owner)
      end
    end

    before_transition any => :abandoned do |task|
      if task.phone_call.in_progress?
        task.phone_call.update_attributes!(state_event: :end, ender: task.abandoner)
      end
    end
  end
end
