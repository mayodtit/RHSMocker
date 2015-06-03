class NewKinsightsMemberTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 7

  belongs_to :subject, class_name: 'User'

  attr_accessible :subject, :subject_id

  validates :member, :subject, presence: true

  before_validation :set_defaults, on: :create

  def set_priority
    self.priority = PRIORITY
  end

  private

  TASK_DESCRIPTION = <<-eof
1. Log into Kinsights
2. Populate member's profile based off their Kinsights profile
3. Copy family notes into member's profile

eof

  def set_defaults
    self.title ||= "New Kinsights Member"
    self.description ||= default_description
    self.creator ||= Member.robot
    self.due_at ||= Time.now + 5.minutes
    true
  end

  def default_description
    TASK_DESCRIPTION + "Kinsights Patient URL: #{subject.kinsights_patient_url}\nKinsights Profile URL: #{subject.kinsights_profile_url}"
  end
end
