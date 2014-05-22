class UserRequest < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :user_request_type

  attr_accessible :user, :user_id, :subject, :subject_id, :name,
                  :user_request_type, :user_request_type_id

  validates :user, :subject, :user_request_type, :name, presence: true
end
