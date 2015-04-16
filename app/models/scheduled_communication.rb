class ScheduledCommunication < ActiveRecord::Base
  belongs_to :sender, class_name: 'Member',
                      inverse_of: :outbound_scheduled_communications
  belongs_to :recipient, class_name: 'Member',
                         inverse_of: :inbound_scheduled_communications
  belongs_to :reference, polymorphic: true
  belongs_to :delayed_job, class_name: 'Delayed::Backend::ActiveRecord::Job'
  symbolize :reference_event, in: %i(free_trial_ends_at), allow_nil: true
  serialize :variables, Hash

  attr_accessible :sender, :sender_id, :recipient, :recipient_id,
                  :reference, :reference_id, :reference_type, :reference_event,
                  :state_event, :publish_at, :delivered_at, :variables,
                  :relative_days, :delayed_job, :delayed_job_id

  validates :recipient, presence: true
  validates :sender, presence: true, if: ->(s){s.sender_id}
  validates :reference, presence: true, if: ->(s){s.reference_id || s.reference_type}
  validates :reference, presence: true, if: ->(s){s.reference_event}
  validates :reference_event, presence: true, if: ->(s){s.reference}
  validates :reference_event, inclusion: {in: %i(free_trial_ends_at)}, if: ->(s){s.reference}
  validates :relative_days, presence: true, if: ->(s){s.reference}
  validates :relative_days, numericality: {only_integer: true}, allow_nil: true

  def self.scheduled
    where(state: :scheduled)
  end

  def self.delivered
    where(state: :delivered)
  end

  def self.held
    where(state: :held)
  end

  def self.canceled
    where(state: :canceled)
  end

  def self.publish_at_past_time(time=Time.now)
    where('publish_at < ?', time)
  end

  def self.non_system
    where('type != ?', ScheduledSystemMessage.name)
  end

  def self.without_reference_event
    where(reference_event: nil)
  end

  def self.hold_scheduled!
    scheduled.non_system.each do |c|
      c.hold!
    end
  end

  def publish_at_past_time?(time=Time.now)
    publish_at.try(:<, time) || false
  end

  def update_publish_at_from_calculation!
    return unless scheduled? || held?
    return unless reference
    if calculated_publish_at < Time.now
      update_attributes!(state_event: :cancel,
                         publish_at: calculated_publish_at)
    else
      update_attributes!(publish_at: calculated_publish_at)
    end
  end

  def create_delivery_job
    transaction do
      job = DeliverScheduledCommunicationJob.create(id, publish_at)
      update_attribute(:delayed_job_id, job.id)
    end
  end

  protected

  def delivered_at_is_nil
    errors.add(:delivered_at, 'must be nil') unless delivered_at.nil?
  end

  state_machine initial: :scheduled do
    state :scheduled do
      validates :publish_at, presence: true
      validate {|communication| communication.delivered_at_is_nil}
    end

    state :delivered do
      validates :delivered_at, presence: true
    end

    event :deliver do
      transition %i(scheduled held) => :delivered, if: ->(m){m.can_deliver?}
      transition %i(scheduled held) => :failed
    end

    event :hold do
      transition %i(scheduled failed) => :held
    end

    event :resume do
      transition %i(held failed) => :scheduled
    end

    event :cancel do
      transition %i(scheduled held failed) => :canceled
    end

    before_transition any => :delivered do |communication, transition|
      communication.delivered_at = Time.now
    end
  end

  private

  def calculated_publish_at
    if relative_days > 0
      relative_days.abs.business_days.after(reference_time.pacific.nine_oclock)
    else
      relative_days.abs.business_days.before(reference_time.pacific.nine_oclock)
    end
  end

  def reference_time
    reference.public_send(reference_event)
  end
end
