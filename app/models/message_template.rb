class MessageTemplate < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_template
  has_many :message_workflows, through: :message_workflow_templates

  attr_accessible :name, :text

  validates :name, :text, presence: true
  validates :name, uniqueness: true

  def create_message(sender, consult, no_notification=false)
    Message.create(user: sender,
                   consult: consult,
                   text: self.class.formatted_text(sender, consult, text),
                   no_notification: no_notification)
  end

  def create_scheduled_message(sender, consult, publish_at)
    ScheduledMessage.create(sender: sender,
                            consult: consult,
                            publish_at: publish_at,
                            text: text)
  end

  def self.can_format_text?(sender, consult, text)
    unless consult.initiator.salutation.present? && sender.first_name.present?
      return false
    end
    text.gsub(/\*\|.*?\|\*/) do |ftext|
      case ftext
      when '*|member_first_name|*'
        consult.initiator.salutation
      when '*|sender_first_name|*'
        sender.first_name
      else
        return false
      end
    end
    true
  end

  def self.formatted_text(sender, consult, text)
    unless consult.initiator.salutation.present? && sender.first_name.present?
      raise 'All merge tags not defined, aborting...'
    end

    text.gsub(/\*\|.*?\|\*/) do |ftext|
      case ftext
      when '*|member_first_name|*'
        consult.initiator.salutation
      when '*|sender_first_name|*'
        sender.first_name
      else
        raise 'All merge tags not replaced, abort abort.'
      end
    end
  end
end
