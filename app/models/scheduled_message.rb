class ScheduledMessage < ActiveRecord::Base
  belongs_to :sender, class_name: 'Member'
  belongs_to :consult
  belongs_to :message

  attr_accessible :sender, :sender_id, :consult, :consult_id, :message,
                  :message_id, :text, :state_event, :publish_at, :sent_at

  validates :sender, :consult, :text, presence: true

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
      transition :scheduled => :sent
    end

    before_transition :scheduled => :sent do |message, transition|
      message.sent_at = Time.now
      message.build_message(user: message.sender,
                            consult: message.consult,
                            text: message.text)
    end
  end
end
