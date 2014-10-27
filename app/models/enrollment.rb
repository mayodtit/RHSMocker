class Enrollment < ActiveRecord::Base
  attr_accessible :token, :email, :first_name, :last_name, :birth_date,
                  :advertiser_id, :time_zone

  validates :token, presence: true, uniqueness: true

  before_validation :set_token, on: :create

  private

  def set_token
    self.token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(token: new_token)
    end
  end
end
