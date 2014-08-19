class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  mount_uploader :bio_image, PhaProfileBioImageUploader
  mount_uploader :full_page_bio_image, PhaProfileFullPageBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :full_page_bio_image, :bio, :weekly_capacity,
                  :capacity_weight, :mayo_pilot

  validates :user, presence: true
  validates :capacity_weight, numericality: {only_integer: true,
                                             greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 100}
  validates :mayo_pilot, inclusion: {in: [true, false]}

  before_validation :set_defaults

  def self.mayo_pilot
    where(mayo_pilot: true)
  end

  def self.with_capacity
    all.each.reject{|p| p.max_capacity?}
  end

  def self.next_pha_profile(pilot=false)
    capacity_hash = {}
    search_scope = pilot ? mayo_pilot.with_capacity : with_capacity
    capacity_total = search_scope.inject(0) do |sum, profile|
      if profile.capacity_weight > 0
        sum += profile.capacity_weight
        capacity_hash[sum] = profile
      end
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

  def full_page_bio_image_url
    full_page_bio_image.url
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
    self.mayo_pilot = false if mayo_pilot.nil?
    true
  end

  def recent_owned_members_count
    user.owned_members
        .signed_up
        .where('signed_up_at > ?', Time.now.pacific.beginning_of_week)
        .count
  end
end
