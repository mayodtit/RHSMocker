class Session < ActiveRecord::Base
  belongs_to :member

  attr_accessible :member, :auth_token, :device_id, :apns_token, :gcm_id,
                  :device_os, :device_app_version, :device_app_build,
                  :device_timezone, :device_notifications_enabled

  validates :member, :auth_token, presence: true

  before_validation :set_auth_token

  private

  def set_auth_token
    self.auth_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(auth_token: new_token)
    end
  end
end
