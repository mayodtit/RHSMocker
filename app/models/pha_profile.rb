class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :bio, :accepting_new_members

  validates :user, presence: true
  validates :accepting_new_members, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

  def bio_image_url
    bio_image.url
  end

  private

  def set_defaults
    self.accepting_new_members ||= false
    true
  end
end
