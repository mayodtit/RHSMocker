class InsurancePolicyTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :subject, class_name: 'User'

  attr_accessible :subject, :subject_id

  validates :member, :subject, presence: true

  private

  def default_queue
    :hcc
  end

  TASK_DESCRIPTION = <<-eof
1. Verify new insurance policy is in their profile.
2. Acknowledge to the member that we've heard them and are processing their Insurance policy.
3. Extract information from the card and put it into the insurance policy fields.
  eof

  def set_defaults
    self.title ||= "Member added new Insurance Policy"
    self.description ||= TASK_DESCRIPTION
    self.creator ||= Member.robot
    self.due_at ||= Time.now + 5.minutes
    self.priority ||= 7
    super
  end
end
