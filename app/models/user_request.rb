class UserRequest < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :user_request_type
  serialize :request_data, Hash

  attr_accessible :user, :user_id, :subject, :subject_id, :name,
                  :user_request_type, :user_request_type_id, :request_data

  validates :user, :subject, :user_request_type, :name, presence: true
end
