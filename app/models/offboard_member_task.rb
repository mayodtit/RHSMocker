class OffboardMemberTask < Task
  PRIORITY = 1
  OFFBOARDING_WINDOW = 2.business_day

  include ActiveModel::ForbiddenAttributesProtection

  attr_accessible :member_id, :member

  validates :member, :service_type, presence: true

  before_validation :set_owner, on: :create
  before_validation :set_required_attrs, on: :create

  def set_priority
    self.priority = PRIORITY
  end

  def set_required_attrs
    self.title = "Offboard engaged free trial member"
    self.due_at = 1.business_day.before(member.free_trial_ends_at.pacific)
    self.member_free_trial_ends_at = member.free_trial_ends_at
    self.service_type = ServiceType.find_by_name! 'member offboarding'
    self.creator = Member.robot
  end

  def self.create_if_only_for_current_free_trial(member)
    if member.free_trial_ends_at && where(member_id: member.id, member_free_trial_ends_at: member.free_trial_ends_at).count == 0
      create member: member
    end
  end
end
