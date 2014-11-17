class NoTasksTask < Task
  PRIORITY = 7

  include ActiveModel::ForbiddenAttributesProtection

  validates :member, :service_type, presence: true

  before_validation :set_owner, on: :create
  before_validation :set_required_attrs, on: :create

  def set_priority
    self.priority = PRIORITY
  end

  def set_required_attrs
    self.title = "Member has no tasks."
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.creator = Member.robot
  end

  def self.create_if_member_has_no_tasks(member)
    if Task.where(member_id: member.id, type: ['MemberTask', 'UserRequestTask']).open.count == 0
      create member: member
    end
  end
end
