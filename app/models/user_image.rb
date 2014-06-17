class UserImage < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :user_images
  has_many :messages, inverse_of: :user_image, dependent: :nullify
  mount_uploader :image, UserImageUploader

  attr_accessible :user, :user_id, :image, :client_guid

  validates :user, presence: true
  validates :client_guid, uniqueness: true, if: ->(u){u.client_guid.present?}

  def url
    image.url
  end
end
