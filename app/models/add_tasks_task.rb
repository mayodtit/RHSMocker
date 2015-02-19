class AddTasksTask < Task

  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true
  validates :service_type, presence: true

  before_validation :set_required_attrs, on: :create

  def set_required_attrs
    self.title = "Find new services for member"
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.creator = Member.robot
    self.owner = member.pha
    self.assignor = Member.robot
    self.assigned_at = Time.now
    self.due_at = Time.now.pacific.eighteen_oclock
    self.description = "The member current has no tasks in progress."
    self.priority = 0
  end

  def self.create_if_member_has_no_tasks(member)
    if Message.where(user_id: member.id).exists? && Task.where(member_id: member.id, created_at: "< ? #{2.weeks.ago}", type: ['MemberTask', 'UserRequestTask', 'AddTasksTask']).open.count == 0
      create! member: member
    end
  end
end
