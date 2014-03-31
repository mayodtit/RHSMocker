class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader

  validates :user, presence: true

  def bio_image_url
    bio_image.url
  end
end
