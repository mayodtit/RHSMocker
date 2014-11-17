class CommunicationWorkflow < ActiveRecord::Base
  has_many :communication_workflow_templates, inverse_of: :communication_workflow

  attr_accessible :name

  validates :name, presence: true, uniqueness: true

  def self.automated_onboarding
    @automated_onboarding ||= find_by_name('Automated Onboarding 8/22/14')
  end

  def self.automated_offboarding
    @automated_offboarding ||= find_by_name('Automated Offboarding')
  end

  def self.automated_onboarding_something_else
    @automated_onboarding_something_else ||= find_by_name('Automated Onboarding - Something Else')
  end

  def self.automated_onboarding_caring_for
    @automated_onboarding_caring_for ||= find_by_name('Automated Onboarding - Caring For Parent/Child')
  end

  def add_to_member(member)
    initial_time = relative_time
    communication_workflow_templates.each do |cwt|
      cwt.add_to_member(member, initial_time)
    end
  end

  private

  def relative_time
    time = Time.now.pacific.nine_oclock
    if !time.to_date.weekday?
      1.business_day.after(1.business_day.before(time)) # previous_business_day
    else
      time
    end
  end
end
