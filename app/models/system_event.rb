class SystemEvent < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :system_event_template, inverse_of: :system_events
  belongs_to :parent, class_name: 'SystemEvent',
                      inverse_of: :children
  has_many :children, class_name: 'SystemEvent',
                      foreign_key: :parent_id,
                      inverse_of: :parent,
                      dependent: :destroy
  belongs_to :resource, polymorphic: true
  has_one :system_action, inverse_of: :system_event
  belongs_to :delayed_job, class_name: 'Delayed::Backend::ActiveRecord::Job'

  attr_accessible :user, :user_id, :system_event_template, :system_event_template_id, :trigger_at, :state,
                  :resource, :resource_id, :resource_type, :resource_attribute

  validates :user, :system_event_template, :trigger_at, presence: true

  after_commit :create_delivery_job!

  protected

  def trigger_system_event!
    TriggerSystemEventService.new(system_event: self).call
  end

  private

  state_machine initial: :scheduled do
    event :trigger do
      transition :scheduled => :triggered
    end

    event :cancel do
      transition :scheduled => :canceled
    end

    after_transition on: :trigger, do: :trigger_system_event!
  end

  def create_delivery_job!
    return unless previous_changes[:trigger_at]
    begin
      job = TriggerSystemEventJob.create(id)
      update_attribute(:delayed_job_id, job.id)
    rescue ActiveRecord::StatementInvalid
      Rails.logger.error("Failed to create DeliverScheduledCommunicationJob for ScheduledCommunication with id=#{scheduled.id}")
    end
  end
end
