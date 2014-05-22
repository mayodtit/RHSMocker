class UserRequestType < ActiveRecord::Base
  has_many :user_requests

  attr_accessible :name

  validates :name, presence: true
end
