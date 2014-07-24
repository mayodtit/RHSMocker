class ScheduledMessage < ActiveRecord::Base
  belongs_to :sender, class_name: 'Member'
  belongs_to :consult
  belongs_to :message
  serialize :variables, Hash

  attr_accessible :sender, :sender_id, :consult, :consult_id, :message,
                  :message_id, :text, :state_event, :publish_at, :sent_at,
                  :variables

  validates :sender, :consult, :text, presence: true

  def self.scheduled
    where(state: :scheduled)
  end

  def self.held
    where(state: :held)
  end

  def self.publish_at_past_time(time=Time.now)
    where('publish_at < ?', time)
  end

  def formatted_text
    MessageTemplate.formatted_text(sender, consult, text, variables)
  end

  def can_send_message?
    MessageTemplate.can_format_text?(sender, consult, text, variables)
  end

  protected

  def sent_at_is_nil
    errors.add(:sent_at, 'must be nil') unless sent_at.nil?
  end

  private

  state_machine initial: :scheduled do
    state :scheduled do
      validates :publish_at, presence: true
      validate {|message| message.sent_at_is_nil}
    end

    state :sent do
      validates :sent_at, presence: true
    end

    event :send_message do
      transition %i(scheduled held) => :sent, if: ->(m){m.can_send_message?}
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

    before_transition any => :sent do |message, transition|
      message.sent_at = Time.now
      message.build_message(user: message.sender,
                            consult: message.consult,
                            text: message.formatted_text)
    end
  end
end
