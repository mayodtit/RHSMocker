class UserFile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :file, :user_id
  mount_uploader :file, UserFileUploader
  validates :user, presence: true
end
