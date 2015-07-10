class OffboardMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  OFFBOARDING_WINDOW = 1.business_day

  validates :member, :service_type, presence: true

  def self.create_if_only_for_current_free_trial(member)
    if member.free_trial_ends_at && where(member_id: member.id, member_free_trial_ends_at: member.free_trial_ends_at).count == 0
      create member: member
    end
  end

  private

  def set_defaults
    self.title = "Offboard engaged free trial member"
    self.service_type = ServiceType.find_by_name! 'member offboarding'
    self.creator = Member.robot
    self.due_at = 1.business_day.before(member.free_trial_ends_at.pacific)
    self.member_free_trial_ends_at = member.free_trial_ends_at
    self.owner ||= member.try(:pha)
    super
  end
end
