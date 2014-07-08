class MessageTemplate < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_template
  has_many :message_workflows, through: :message_workflow_templates

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
