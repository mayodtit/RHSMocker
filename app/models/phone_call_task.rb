class PhoneCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 15
  belongs_to :phone_call

  delegate :consult, to: :phone_call
  delegate :subject, to: :consult

  attr_accessible :phone_call_id, :phone_call

  validates :phone_call, presence: true
  validate :one_open_per_phone_call

  before_validation :set_role, on: :create
  before_validation :set_member

  def default_queue
    if (role && for_nurse?) || phone_call.to_nurse? 
      :nurse
    else
      :hcc
    end
  end

  def set_role
    self.role_id = self.role_id = phone_call.to_role_id if role_id.nil?
  end

  def set_member
    self.member = phone_call.user if member.nil? && phone_call.present?
  end

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

  def one_open_per_phone_call
    return unless open?
    task = self.class.open.where(phone_call_id: phone_call_id).first
    if task && task.id != id
      errors.add(:phone_call_id, "open PhoneCallTask already exists for #{phone_call_id}")
    end
  end

  def set_priority
    self.priority = PRIORITY
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
end
