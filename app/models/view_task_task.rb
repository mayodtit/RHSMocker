class ViewTaskTask < Task

  belongs_to :assigned_task, class_name: 'Task'
  attr_accessible :assigned_task
  validates :assigned_task, presence: true

  def self.create_task_for_task(task)
    create!(
        assigned_task: task,
        title: "Task assigned to you by #{task.assignor.full_name}",
        member: task.member,
        creator: Member.robot,
        assignor: task.assignor,
        owner: task.owner,
        due_at: Time.now,
        priority: 30
    )
    task.update_attributes!(state: 'unclaimed', visible_in_queue: false)
  end

  state_machine do

    before_transition any => :completed do |task|
      task.assigned_task.update_attributes!(visible_in_queue: true)
    end
  end
end
