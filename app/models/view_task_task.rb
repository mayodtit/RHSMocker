class ViewTaskTask < Task

  belongs_to :assigned_task, class_name: 'Task'
  attr_accessible :assigned_task
  validates :assigned_task, :owner, :assignor, :member, presence: true

  def self.create_task_for_task(task)
    return task if task.owner == task.assignor || task.urgent?
    view_task = create!(
        assigned_task: task,
        title: task.title,
        member: task.member,
        creator: Member.robot,
        assignor: task.assignor,
        owner: task.owner,
        due_at: Time.now,
        priority: 7,
        day_priority: 15)
    task.update_attributes!(visible_in_queue: false)
    view_task
  end

  state_machine do

    after_transition any => :completed do |task|
      if ViewTaskTask.where(assigned_task_id: task.assigned_task_id).open.empty?
        task.assigned_task.update_attributes!(visible_in_queue: true)
      end
    end

    after_transition any => :started do |task|
      task.complete
    end
  end
end
