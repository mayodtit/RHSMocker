class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :bio, :weekly_capacity

  validates :user, presence: true

  def bio_image_url
    bio_image.url
  end

  def max_capacity?
    if weekly_capacity.nil?
      false
    else
      recent_owned_members_count >= weekly_capacity
    end
  end

  private

  def recent_owned_members_count
    user.owned_members
        .signed_up
        .where('signed_up_at > ?', Time.now.pacific.beginning_of_week)
        .count
  end
end
