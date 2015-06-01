class MessageTemplate < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_template
  has_many :system_message_workflow_templates, inverse_of: :message_template
  has_many :communication_workflows, through: :message_workflow_templates
  belongs_to :content
  belongs_to :onboarding_group

  attr_accessible :name, :text, :subject, :content, :content_id

  validates :name, :text, presence: true
  validates :name, uniqueness: true
  validates :content, presence: true, if: ->(m){m.content_id}

  def create_message(sender, consult, no_notification=false, system_message=false, automated=false)
    Message.create(user: sender,
                   consult: consult,
                   text: self.class.formatted_text(sender, consult.initiator, text),
                   content: content,
                   no_notification: no_notification,
                   system: system_message,
                   automated: automated)
  end

  def create_scheduled_message(sender, consult, publish_at, variables={})
    ScheduledMessage.create(sender: sender,
                            recipient: consult.initiator,
                            publish_at: publish_at,
                            text: text,
                            variables: variables,
                            content: content)
  end

  def create_scheduled_plain_text_email(sender, recipient, publish_at, variables={})
    ScheduledPlainTextEmail.create(sender: sender,
                                   recipient: recipient,
                                   publish_at: publish_at,
                                   subject: subject,
                                   text: text,
                                   variables: variables)
  end

  def self.can_format_text?(sender, recipient, text, variables={})
    nux_answer = recipient.nux_answer || NuxAnswer.find_by_name('something else')
    text.gsub(/\*\|.*?\|\*/) do |ftext|
      if ftext == '*|member_first_name|*' && recipient.salutation.present?
        recipient.salutation
      elsif ftext == '*|sender_first_name|*' && sender.first_name.present?
        sender.first_name
      elsif ftext == '*|pha_first_name|*' && recipient.try(:pha).try(:first_name).try(:present?)
        recipient.pha.first_name
      elsif ftext == '*|pha_next_available|*'
        Time.now.next_business_day_in_words (recipient.time_zone ? ActiveSupport::TimeZone.new(recipient.time_zone) : nil)
      elsif ftext == '*|day_of_reference_event|*' && recipient.try(:free_trial_ends_at)
        # TODO - generalize this for all events
        if Time.now.pacific.to_date == recipient.free_trial_ends_at.pacific.to_date
          'today'
        else
          recipient.free_trial_ends_at.pacific.strftime('%A')
        end
      elsif ftext == '*|nux_answer|*' && nux_answer.present?
        nux_answer.phrase
      elsif variables.has_key?(ftext.gsub(/\*\||\|\*/, ''))
        variables[ftext.gsub(/\*\||\|\*/, '')]
      else
        return false
      end
    end
    true
  end

  def self.formatted_text(sender, recipient, text, variables={})
    nux_answer = recipient.nux_answer || NuxAnswer.find_by_name('something else')
    text.gsub(/\*\|.*?\|\*/) do |ftext|
      if ftext == '*|member_first_name|*' && recipient.salutation.present?
        recipient.salutation
      elsif ftext == '*|sender_first_name|*' && sender.first_name.present?
        sender.first_name
      elsif ftext == '*|pha_first_name|*' && recipient.try(:pha).try(:first_name).try(:present?)
        recipient.pha.first_name
      elsif ftext == '*|pha_next_available|*'
        Time.now.next_business_day_in_words (recipient.time_zone ? ActiveSupport::TimeZone.new(recipient.time_zone) : nil)
      elsif ftext == '*|day_of_reference_event|*' && recipient.try(:free_trial_ends_at)
        # TODO - generalize this for all events
        if Time.now.pacific.to_date == recipient.free_trial_ends_at.pacific.to_date
          'today'
        else
          recipient.free_trial_ends_at.pacific.strftime('%A')
        end
      elsif ftext == '*|nux_answer|*' && nux_answer.present?
        nux_answer.phrase
      elsif variables.has_key?(ftext.gsub(/\*\||\|\*/, ''))
        variables[ftext.gsub(/\*\||\|\*/, '')]
      else
        raise 'All merge tags not replaced, abort abort.'
      end
    end
  end
end
