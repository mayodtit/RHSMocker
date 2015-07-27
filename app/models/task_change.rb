class TaskChange < ActiveRecord::Base
  belongs_to :task
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash
  attr_accessible :task, :task_id, :created_at, :event, :from, :to,
                  :actor, :actor_id, :data, :reason

  validates :task, :actor, presence: true

  before_validation :set_created_at

  after_commit :publish, on: :create

  def publish
    if actor.email.include? "+robot"
      actor_name = 'Better Bot'
    else
      actor_name = actor.first_name
    end
    # For existing tasks assigned to someone
    if %w(update).include?(event) && data['owner_id'] && data['owner_id'].second != actor_id

      case task.type
        when 'MemberTask'
          message = "#{actor_name} assigned you a #{task.service_type.bucket} task"
        when 'PhoneCallTask'
          message = "#{actor_name} assigned you to a call"
        when 'MessageTask'
          message = "#{actor_name} assigned you a message"
        when 'UserRequestTask'
          message = "#{actor_name} assigned you an appointment request"
        when 'ParsedNurselineRecordTask'
          message = "#{actor_name} assigned you a nurseline summary"
        when 'UpgradeTask'
          message = "#{actor_name} assigned you a user upgrade task"
        when 'OffboardMemberTask'
          message = "#{actor_name} assigned you an offboard task"
      end
      PubSub.publish "/users/#{task.owner_id}/notifications/tasks", {msg: message, id: task_id, assignedTo: task.owner_id}
    # For new tasks assigned to someone
    elsif (event.nil? && !task.owner_id.nil? && task.owner_id != actor_id)

      case task.type
        when 'MemberTask'
          message = "#{actor_name} assigned you a #{task.service_type.bucket} task"
        when 'PhoneCallTask'
          message = "#{actor_name} assigned you to a call"
        when 'MessageTask'
          message = "#{actor_name} assigned you a message"
        when 'UserRequestTask'
          message = "#{actor_name} assigned you an appointment request"
        when 'ParsedNurselineRecordTask'
          message = "#{actor_name} assigned you a nurseline summary"
        when 'UpgradeTask'
          message = "#{actor_name} assigned you a user upgrade task"
        when 'OffboardMemberTask'
          message = "#{actor_name} assigned you an offboard task"
      end
      PubSub.publish "/users/#{task.owner_id}/notifications/tasks", {msg: message, id: task_id, assignedTo: task.owner_id}
    # For new unassigned tasks
    elsif event.nil? && task.owner_id.nil? && task.role_id == Role.pha.try(:id)
      case task.type
        when 'MemberTask'
          message = "New #{task.service_type.bucket} task"
        when 'PhoneCallTask'
          message = "New inbound phone call"
        when 'UserRequestTask'
          message = "New appointment request"
        when 'ParsedNurselineRecordTask'
          message = "New nursline sumamry"
        when 'UpgradeTask'
          message = "New user upgrade task"
        when 'OffboardMemberTask'
          message = "New offboard task"
      end
      Role.pha.users.where(on_call: true).each do |pha|
        PubSub.publish "/users/#{pha.id}/notifications/tasks", {msg: message, id: task_id, assignedTo: task.owner_id}
      end
    end
  end

  def set_created_at
    self.created_at = Time.now unless self.created_at
  end
end
