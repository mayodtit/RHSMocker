class InsurancePolicyTask < Task
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
1. Verify new insurance policy is in their profile
2. Acknowledge to the member that we've heard them and are processing their Insurance policy.
  eof

  def set_defaults
    self.title ||= "Member added new Insurance Policy"
    self.description ||= TASK_DESCRIPTION
    self.creator ||= Member.robot
    self.due_at ||= Time.now + 5.minutes
    true
  end
end
