class MessageTemplate < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_template
  has_many :message_workflows, through: :message_workflow_templates

  attr_accessible :name, :text

  validates :name, :text, presence: true
  validates :name, uniqueness: true

  def create_message(sender, consult, no_notification=false, system_message=false)
    Message.create(user: sender,
                   consult: consult,
                   text: self.class.formatted_text(sender, consult, text),
                   no_notification: no_notification,
                   off_hours: system_message)
  end

  def create_scheduled_message(sender, consult, publish_at)
    ScheduledMessage.create(sender: sender,
                            consult: consult,
                            publish_at: publish_at,
                            text: text)
  end

  def self.can_format_text?(sender, consult, text, variables={})
    text.gsub(/\*\|.*?\|\*/) do |ftext|
      if ftext == '*|member_first_name|*' && consult.initiator.salutation.present?
        consult.initiator.salutation
      elsif ftext == '*|sender_first_name|*' && sender.first_name.present?
        sender.first_name
      elsif ftext == '*|pha_first_name|*' && consult.initiator.try(:pha).try(:first_name).try(:present?)
        consult.initiator.pha.first_name
      elsif variables.has_key?(ftext.gsub(/\*\||\|\*/, ''))
        variables[ftext.gsub(/\*\||\|\*/, '')]
      else
        return false
      end
    end
    true
  end

  def self.formatted_text(sender, consult, text, variables={})
    text.gsub(/\*\|.*?\|\*/) do |ftext|
      if ftext == '*|member_first_name|*' && consult.initiator.salutation.present?
        consult.initiator.salutation
      elsif ftext == '*|sender_first_name|*' && sender.first_name.present?
        sender.first_name
      elsif ftext == '*|pha_first_name|*' && consult.initiator.try(:pha).try(:first_name).try(:present?)
        consult.initiator.pha.first_name
      elsif variables.has_key?(ftext.gsub(/\*\||\|\*/, ''))
        variables[ftext.gsub(/\*\||\|\*/, '')]
      else
        raise 'All merge tags not replaced, abort abort.'
      end
    end
  end
end
