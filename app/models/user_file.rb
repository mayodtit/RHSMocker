class UserFile < ActiveRecord::Base
  belongs_to :user

  attr_accessible :file, :user_id
  validates :user, :file, presence: true

  mount_uploader :file, UserFileUploader

  def url
    file.url
  end
end
