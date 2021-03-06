class Session < ActiveRecord::Base
  include TimeoutModule
  belongs_to :member

  attr_accessible :member, :auth_token, :device_id, :apns_token, :gcm_id,
                  :device_os, :device_os_version, :device_app_version, :device_app_build,
                  :device_timezone, :device_notifications_enabled, :device_model,
                  :advertiser_id, :disabled_at, :logging_command, :logging_level

  validates :member, presence: true
  validates :auth_token, presence: true, uniqueness: true

  before_validation :set_auth_token
  before_destroy :unset_notification_tokens

  private

  def set_auth_token
    self.auth_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless self.class.exists?(auth_token: new_token)
    end
  end

  def unset_notification_tokens
    self.apns_token = nil
    self.gcm_id = nil
  end
end
