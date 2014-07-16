class MessageWorkflow < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_workflow
  has_many :message_templates, through: :message_workflow_templates

  attr_accessible :name

  validates :name, presence: true, uniqueness: true

  def self.automated_onboarding
    @automated_onboarding ||= find_by_name('Automated Onboarding')
  end

  def add_to_member(member)
    initial_time = nine_oclock_on_date(Time.now.pacific)
    message_workflow_templates.each do |mwt|
      ScheduledMessage.create!(sender: member.pha,
                               consult: member.master_consult,
                               text: mwt.message_template.text,
                               publish_at: mwt.days_delayed.business_days.after(initial_time))
    end
  end

  private

  def nine_oclock_on_date(time)
    Time.new(time.year, time.month, time.day, 9, 0, 0, time.strftime('%:z'))
  end
end
