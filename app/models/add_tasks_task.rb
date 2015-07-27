class AddTasksTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true
  validates :service_type, presence: true

  def self.create_if_member_has_no_tasks(member)
    if Message.where(user_id: member.id).exists? && Task.where(member_id: member.id, type: ['MemberTask', 'UserRequestTask', 'AddTasksTask']).open.count == 0
      create! member: member
    end
  end

  private

  def default_queue
    :pha
  end

  def set_defaults
    self.title = "Find new services for member"
    self.description = "The member current has no tasks in progress."
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.owner = member.pha
    self.creator = Member.robot
    self.assignor = Member.robot
    self.assigned_at = Time.now
    self.due_at = Time.now.pacific.eighteen_oclock
    super
  end
end
