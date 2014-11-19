class AddTasksTask < Task

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :subject, class_name: 'User'

  attr_accessible :subject_id, :subject

  validates :member, presence: true
  validates :subject, presence: true
  validates :service_type, presence: true

  before_validation :set_required_attrs, on: :create

  def set_required_attrs
    self.title = "Find new services for member"
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.creator = Member.robot
    self.due_at = Time.end_of_workday(Time.now)
    self.subject = member
    self.description = "The member currently has no current tasks assigned."
    self.priority = 0
  end

  def self.create_if_member_has_no_tasks(member)
    if Task.where(member_id: member.id, type: ['MemberTask', 'UserRequestTask', 'AddTasksTask']).open.count == 0
      create! member: member
    end
  end
end
