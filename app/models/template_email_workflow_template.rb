class TemplateEmailWorkflowTemplate < CommunicationWorkflowTemplate
  attr_accessible :template

  validates :template, presence: true

  def add_to_member(member, relative_time)
    ScheduledTemplateEmail.create!(sender: member.pha,
                                   recipient: member,
                                   template: template,
                                   publish_at: days_delayed.business_days.after(relative_time))
  end
end
