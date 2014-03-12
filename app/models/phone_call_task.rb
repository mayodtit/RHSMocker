class PhoneCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :phone_call

  delegate :consult, to: :phone_call
  delegate :subject, to: :consult

  attr_accessible :phone_call_id, :phone_call

  validates :phone_call_id, presence: true
  validates :phone_call, presence: true, if: lambda { |t| t.phone_call_id }

  before_validation :set_role, on: :create

  def set_role
    self.role_id = phone_call.to_role_id if role_id.nil?
  end

  def member
    phone_call.user || (consult && consult.initiator)
  end

  state_machine :initial => :unassigned do
    before_transition any => :unassigned do |task|
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
