class MessageMemberTask < Task

  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true
  validates :service_type, presence: true

  before_validation :set_required_attrs, on: :create

  def default_queue
    :pha
  end

  def set_required_attrs
    self.title = "Message member"
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.creator = Member.robot
    self.owner = member.pha
    self.assignor = Member.robot
    self.assigned_at = Time.now
    self.due_at = Time.now.pacific.eighteen_oclock
    self.description = "Member has not been messages in a week. Please send them a message."
    self.priority = 0
  end

  def self.create_task_for_member(member)
    if !MessageMemberTask.open.find_by_member_id(member.id)
      create! member: member
    end
  end
end
