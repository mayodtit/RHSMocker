class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :bio, :weekly_capacity,
                  :capacity_weight

  validates :user, presence: true
  validates :capacity_weight, numericality: {only_integer: true,
                                             greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 100}

  before_validation :set_defaults

  def self.with_capacity
    all.each.reject{|p| p.max_capacity?}
  end

  def self.next_pha_profile
    capacity_hash = {}
    capacity_total = with_capacity.inject(0) do |sum, profile|
      sum += profile.capacity_weight
      capacity_hash[sum] = profile
      sum
    end

    index = (capacity_total > 0) ? Random.rand(capacity_total) : 0 # [0..total)

    capacity_hash.each do |capacity, profile|
      if index < capacity
        return profile
      end
    end

    nil
  end

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
    self.capacity_weight ||= 0
  end

  def recent_owned_members_count
    user.owned_members
        .signed_up
        .where('signed_up_at > ?', Time.now.pacific.beginning_of_week)
        .count
  end
end
