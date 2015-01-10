class WelcomeCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  INITIAL_PRIORITY = 0
  ALERT_PRIORITY = 30
  TIME_BEFORE_CALL = 15

  belongs_to :scheduled_phone_call
  belongs_to :delayed_job, class_name: 'Delayed::Backend::ActiveRecord::Job'

  attr_accessible :scheduled_phone_call

  validates :scheduled_phone_call, presence: true

  before_validation :set_member

  after_create :set_reminder

  def set_member
    self.member = scheduled_phone_call.user if member.nil? && scheduled_phone_call.present?
  end

  state_machine  do
    before_transition any => :completed do |task|
      task.scheduled_phone_call.update_attributes!(state_event: :end, ender: task.owner)
    end

    before_transition any => :abandoned do |task|
      if task.delayed_job
        task.delayed_job.destroy
        task.delayed_job = nil
      end
      task.scheduled_phone_call.update_attributes!(state_event: :cancel, canceler: task.abandoner)
    end
  end

  def self.create_task!(scheduled_phone_call)
    create!(
      title: 'Welcome Call',
      creator: Member.robot,
      due_at: scheduled_phone_call.scheduled_at,
      priority: INITIAL_PRIORITY,
      scheduled_phone_call: scheduled_phone_call,
      owner: scheduled_phone_call.owner,
      assignor: Member.robot
    )
  end

  def update_task!
    update_attributes!(
      due_at: scheduled_phone_cal l.scheduled_at,
      priority: INITIAL_PRIORITY,
      owner: scheduled_phone_call.owner,
      assignor: Member.robot
    )
  end

  def self.set_priority_high(welcome_call_task_id)
    task = WelcomeCallTask.find welcome_call_task_id
    if task.open?
      task.update_attributes! priority: ALERT_PRIORITY
      body = "You have a Welcome Call Scheduled with #{task.member.full_name} in 15 minutes."
      PubSub.publish "/users/#{task.owner.id}/notifications/tasks", {msg: body, id: task.id, assignedTo: task.owner.id}
      if !task.owner.text_phone_number.nil?
        TwilioModule.message task.owner.text_phone_number, body
      end
    end
  end

  def set_reminder
    self.delayed_job = WelcomeCallTask.delay(run_at: TIME_BEFORE_CALL.minutes.until(self.due_at)).set_priority_high self.id
  end
end
