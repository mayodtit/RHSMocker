class WelcomeCallTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 0
  ALERT_PRIORITY = 20
  TIME_BEFORE_CALL = 15

  belongs_to :scheduled_phone_call
  belongs_to :delayed_job, class_name: 'Delayed::Backend::ActiveRecord::Job'

  attr_accessible :scheduled_phone_call

  validates :scheduled_phone_call, presence: true

  after_create :set_reminder

  state_machine do
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

  def create_task!(scheduled_phone_call)
    create!(
      title: 'Welcome Call',
      creator: Member.robot,
      due_at: scheduled_at,
      priority: 0,
      scheduled_phone_call: scheduled_phone_call
    )
  end

  def self.set_priority_high(welcome_call_task_id)
    task = WelcomeCallTask.find(welcome_call_task_id)
    task.priority = ALERT_PRIORITY
    body = "You have a Welcome Call Scheduled with #{task.user.full_name} in 15 minutes."
    TwilioModule.message task.owner.phone, body
  end

  def set_reminder
    self.delayed_job = WelcomeCallTask.delay(run_at: TIME_BEFORE_CALL.minutes.until(self.due_at)).set_priority_high self.id
  end
end
