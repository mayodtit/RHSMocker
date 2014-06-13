class UserImage < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :user_images
  mount_uploader :image, UserImageUploader

  attr_accessible :user, :user_id, :image

  validates :user, presence: true

  def url
    image.url
  end
end
