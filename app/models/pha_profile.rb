class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :bio, :accepting_new_members,
                  :weekly_capacity

  validates :user, presence: true
  validates :accepting_new_members, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

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

  def set_defaults
    self.accepting_new_members ||= false
    true
  end

  def recent_owned_members_count
    user.owned_members
        .where('signed_up_at > ?', Time.now.pacific.beginning_of_week)
        .count
  end
end
