class Enrollment < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :enrollment
  belongs_to :onboarding_group
  belongs_to :referral_code

  attr_accessible :token, :email, :first_name, :last_name, :birth_date,
                  :advertiser_id, :time_zone, :password, :user, :user_id,
                  :advertiser_media_source, :advertiser_campaign, :code,
                  :onboarding_group, :onboarding_group_id, :uout,
                  :referral_code, :referral_code_id, :used_uout
  attr_accessor :password

  validates :user, presence: true, if: ->(e){e.user_id}
  validates :onboarding_group, presence: true, if: ->(e){e.onboarding_group_id}
  validates :referral_code, presence: true, if: ->(e){e.referral_code_id}
  validates :token, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true, :email => true
  validates :uout, uniqueness: true, allow_nil: true
  validates :password, length: {minimum: 8,
                                message: "must be 8 or more characters long"},
                       if: ->(e){e.password}
  validate :email_not_taken_by_member, if: ->(e){e.email && e.user.nil?}

  before_validation :set_token, on: :create

  private

  def set_token
    self.token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(token: new_token)
    end
  end

  def email_not_taken_by_member
    if Member.where(email: email).any?
      errors.add(:email, 'account already exists')
    end
  end
end
