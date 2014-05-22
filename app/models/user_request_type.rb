class UserRequestType < ActiveRecord::Base
  has_many :user_request_type_fields, inverse_of: :user_request_type
  has_many :user_requests

  attr_accessible :name

  validates :name, presence: true
end
