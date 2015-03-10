class UserRequest < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :user_request_type
  serialize :request_data, Hash
  has_one :user_request_task, inverse_of: :user_request

  attr_accessible :user, :user_id, :subject, :subject_id, :name,
                  :user_request_type, :user_request_type_id, :request_data

  validates :user, :subject, :user_request_type, :name, presence: true

  after_create :send_confirmation_message
  after_create :create_task
  private

  def send_confirmation_message
    return unless user.master_consult

    text = "We're working on your appointment request. Look out for more details soon."

    user.master_consult.messages.create(user: Member.robot,
                                        text: text,
                                        system: true)
  end

  def create_task
    create_user_request_task(title: 'New User Request',
                             creator: Member.robot,
                             member: user,
                             subject: subject,
                             due_at: Time.now)
  end
end
