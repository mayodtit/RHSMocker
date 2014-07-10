class OffboardMemberTask < Task
  PRIORITY = 1
  OFFBOARDING_WINDOW = 24.hours

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
    self.due_at = member.free_trial_ends_at - 1.hour
    self.service_type = ServiceType.find_by_name! 'member offboarding'
    self.creator = Member.robot
  end

  def self.create_if_only_within_offboarding_window(member)
    if member.free_trial_ends_at && where('member_id = ? AND (state NOT IN (?) OR (created_at >= ? AND created_at <= ?))', member.id, ['completed', 'abandoned'], member.free_trial_ends_at - OFFBOARDING_WINDOW, member.free_trial_ends_at).count == 0
      create member: member
    end
  end
end
