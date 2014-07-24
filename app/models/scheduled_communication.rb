class ScheduledCommunication < ActiveRecord::Base
  belongs_to :sender, class_name: 'Member'
  serialize :variables, Hash

  attr_accessible :sender, :sender_id, :state_event, :publish_at,
                  :delivered_at, :variables

  validates :sender, presence: true

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
end
