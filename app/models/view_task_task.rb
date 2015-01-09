class ViewTaskTask < Task

  belongs_to :assigned_task, class_name: 'Task'
  attr_accessible :assigned_task
  validates :assigned_task, :owner, :assignor, :member, presence: true

  def self.create_task_for_task(task)
    create!(
        assigned_task: task,
        title: task.title,
        member: task.member,
        creator: Member.robot,
        assignor: task.assignor,
        owner: task.owner,
        due_at: Time.now,
        priority: 7,
        day_priority: 15
    )
    task.update_attributes!(visible_in_queue: false)
  end

  state_machine do

    after_transition any => :completed do |task|
      task.assigned_task.update_attributes!(visible_in_queue: true)
    end

    after_transition any => :started do |task|
      task.complete
    end

  end
end
