class MessageMemberTask < Task

  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true
  validates :service_type, presence: true

  before_validation :set_required_attrs, on: :create

  def set_required_attrs
    self.title = "Message member"
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.creator = Member.robot
    self.owner = member.pha
    self.due_at = Time.end_of_workday(Time.now)
    self.description = "The member has not been messaged in a week"
    self.priority = 0
  end

  def self.create_task_for_member(member)
    if !MessageMemberTask.find_by_member_id(member.id)
      create! member: member
    end
  end
end
