class ReferralCode < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :owned_referral_code
  belongs_to :creator, class_name: 'Member'
  belongs_to :onboarding_group
  has_many :discount_records
  has_many :users, class_name: 'Member',
                   inverse_of: :referral_code,
                   dependent: :nullify

  attr_accessible :user, :user_id, :creator, :creator_id, :onboarding_group,
                  :onboarding_group_id, :name, :code

  validates :code, presence: true, uniqueness: true
  validates :user, presence: true, if: ->(r){r.user_id}
  validates :creator, presence: true, if: ->(r){r.creator_id}
  validates :onboarding_group, presence: true, if: ->(r){r.onboarding_group_id}

  before_validation :set_code, on: :create

  private

  def set_code
    self.code ||= loop do
      new_code = base32_code
      break new_code unless self.class.exists?(code: new_code)
    end
  end

  def base32_code
    Base32::Crockford.encode(SecureRandom.random_number(1000000000), length: 6)
  end
end
