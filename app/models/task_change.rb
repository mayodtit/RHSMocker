class TaskChange < ActiveRecord::Base
  belongs_to :task
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash
  attr_accessible :task, :task_id, :created_at, :event, :from, :to,
                  :actor, :actor_id, :data

  validates :task, :actor, presence: true

  before_validation :set_created_at

  after_create :publish


  def publish
    if event == 'update'
      case task.type
        when 'MemberTask'
          if actor.email.include? "+robot"
            message = "Better Bot assigned you a #{task.service_type.bucket} task"
          else
            message = "#{actor.first_name} assigned you a #{task.service_type.bucket} task"
          end
        when 'PhoneCallTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you to a call'
          else
            message = "#{actor.first_name} assigned you to a call"
          end
        when 'MessageTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a message'
          else
            message = "#{actor.first_name} assigned you a message"
          end
        when 'UserRequestTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you an appointment request'
          else
            message = "#{actor.first_name} assigned you a"
          end
        when 'ParsedNurselineRecordTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a nurseline summary'
          else
            message = "#{actor.first_name} assigned you a nurseline sumamry"
          end
        when 'UpgradeTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a user upgrade task'
          else
            message = "#{actor.first_name} assigned you a user upgrade task"
          end
        when 'OffboardMemberTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you an offboard task'
          else
            message = "#{actor.first_name} assigned you an offboard task"
          end
      end
      PubSub.publish "/users/#{data["owner_id"].second}/tasks/owned/notification", {msg: message, id: task_id, assignedTo: task.owner_id}
    elsif event.nil? && !task.owner_id.nil?
      case task.type
        when 'MemberTask'
          if actor.email.include? "+robot"
            message = "Better Bot assigned you a #{task.service_type.bucket} task"
          else
            message = "#{actor.first_name} assigned you a #{task.service_type.bucket} task"
          end
        when 'PhoneCallTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you to a phone call'
          else
            message = "#{actor.first_name} assigned you to a phone call"
          end
        when 'MessageTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a message'
          else
            message = "#{actor.first_name} assigned you a message"
          end
        when 'UserRequestTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you an appointment request'
          else
            message = "#{actor.first_name} assigned you an appointment request"
          end
        when 'ParsedNurselineRecordTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a nurseline summary'
          else
            message = "#{actor.first_name} assigned you a nurseline sumamry"
          end
        when 'UpgradeTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you a user upgrade task'
          else
            message = "#{actor.first_name} assigned you a user upgrade task"
          end
        when 'OffboardMemberTask'
          if actor.email.include? "+robot"
            message = 'Better Bot assigned you an offboard task'
          else
            message = "#{actor.first_name} assigned you an offboard task"
          end
      end
      PubSub.publish "/users/#{task.owner_id}/tasks/owned/notification", {msg: message, id: task_id, assignedTo: task.owner_id}
    elsif event.nil? && task.owner_id.nil?
      case task.type
        when 'MemberTask', 'task', 'member'
          message = "New #{task.service_type.bucket} task"
        when 'PhoneCallTask'
          message = "New inbound phone call"
        when 'MessageTask'
          message = "New inbound message"
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
        PubSub.publish "/users/#{pha.id}/tasks/owned/notification", {msg: message, id: task_id, assignedTo: task.owner_id}
      end
    end
  end
  def set_created_at
    self.created_at = Time.now unless self.created_at
  end

end
