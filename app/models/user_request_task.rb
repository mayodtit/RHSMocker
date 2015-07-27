class UserRequestTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user_request, inverse_of: :user_request_task
  belongs_to :subject, class_name: 'User'

  attr_accessible :subject, :subject_id, :user_request, :user_request_id

  validates :member, :subject, :user_request, presence: true

  after_update :set_user_request_subject

  private

  def set_defaults
    self.priority ||= 7
    super
  end

  def default_queue
    :hcc
  end

  def set_user_request_subject
    if subject_id_changed? && user_request.subject != subject
      user_request.update_attributes! subject: subject
    end
  end
end
