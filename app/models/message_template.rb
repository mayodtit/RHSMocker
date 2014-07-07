class MessageTemplate < ActiveRecord::Base
  attr_accessible :name, :text

  validates :name, :text, presence: true
  validates :name, uniqueness: true

  def create_message(sender, consult)
    Message.create(user: sender, consult: consult, text: text)
  end

  def create_scheduled_message(sender, consult, publish_at)
    ScheduledMessage.create(sender: sender,
                            consult: consult,
                            publish_at: publish_at,
                            text: text)
  end
end
