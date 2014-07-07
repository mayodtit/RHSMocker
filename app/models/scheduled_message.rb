class ScheduledMessage < ActiveRecord::Base
  belongs_to :sender, class_name: 'Member'
  belongs_to :consult
  belongs_to :message

  attr_accessible :sender, :sender_id, :consult, :consult_id, :message,
                  :message_id, :text, :state_event, :publish_at, :sent_at

  validates :sender, :consult, :text, presence: true

  def self.scheduled
    where(state: :scheduled)
  end

  def self.publish_at_past_time(time=Time.now)
    where('publish_at < ?', time)
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
      transition %i(scheduled held) => :sent
    end

    event :hold do
      transition :scheduled => :held
    end

    event :resume do
      transition :held => :scheduled
    end

    before_transition any => :sent do |message, transition|
      message.sent_at = Time.now
      message.build_message(user: message.sender,
                            consult: message.consult,
                            text: message.text)
    end
  end
end
