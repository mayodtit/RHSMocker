class PhaProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :pha_profile
  belongs_to :nux_answer
  mount_uploader :bio_image, PhaProfileBioImageUploader
  mount_uploader :full_page_bio_image, PhaProfileFullPageBioImageUploader

  attr_accessible :user, :user_id, :bio_image, :full_page_bio_image, :bio, :weekly_capacity,
                  :capacity_weight, :mayo_pilot_capacity_weight, :first_person_bio,
                  :nux_answer, :nux_answer_id, :silence_low_welcome_call_email

  validates :user, presence: true
  validates :capacity_weight, :mayo_pilot_capacity_weight, numericality: {only_integer: true,
                                                                          greater_than_or_equal_to: 0,
                                                                          less_than_or_equal_to: 100}
  validates :silence_low_welcome_call_email, inclusion: {in: [true, false]}

  before_validation :set_defaults

  def self.with_capacity
    all.each.reject{|p| p.max_capacity?}
  end

  def self.next_pha_profile(pilot=false, nux_answer=nil)
    if nux_answer && find_by_nux_answer_id(nux_answer.id)
      return find_by_nux_answer_id(nux_answer.id)
    end

    capacity_hash = {}
    capacity_total = with_capacity.inject(0) do |sum, profile|
      current_weight = pilot ? profile.mayo_pilot_capacity_weight : profile.capacity_weight
      if current_weight > 0
        sum += current_weight
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
    self.mayo_pilot_capacity_weight ||= 0
    self.silence_low_welcome_call_email = false if silence_low_welcome_call_email.nil?
    true
  end

  def recent_owned_members_count
    user.owned_members
        .signed_up
        .where('signed_up_at > ?', Time.now.pacific.beginning_of_week)
        .count
  end
end
