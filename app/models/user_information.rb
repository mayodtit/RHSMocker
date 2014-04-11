class UserInformation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :notes, :highlights

  validates :user, presence: true
  validates :user_id, uniqueness: true
end
