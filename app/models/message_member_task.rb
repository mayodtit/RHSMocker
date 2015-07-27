class MessageMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  validates :member, presence: true
  validates :service_type, presence: true

  def self.create_task_for_member(member)
    if !MessageMemberTask.open.find_by_member_id(member.id)
      create! member: member
    end
  end

  private

  def default_queue
    :pha
  end

  def set_defaults
    self.title = "Message member"
    self.description = "Member has not been messages in a week. Please send them a message."
    self.service_type = ServiceType.find_by_name! 're-engagement'
    self.owner = member.pha
    self.creator = Member.robot
    self.assignor = Member.robot
    self.assigned_at = Time.now
    self.due_at = Time.now.pacific.eighteen_oclock
    super
  end
end
