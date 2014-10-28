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
    if event == "update"
      PubSub.publish "/users/#{data["owner_id"].second}/tasks/owned/notification", {msg: "A task has been assigned to you.", id: task_id}
    end
    if event.nil? && task.owner_id.nil?
      Role.pha.users.where(on_call: true).each do |pha|
        PubSub.publish "/users/#{pha.id}/tasks/owned/notification", {msg: "A new unassigned task has been created", id: task_id}
      end
    end
  end
  def set_created_at
    self.created_at = Time.now unless self.created_at
  end

end
