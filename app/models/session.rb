class Session < ActiveRecord::Base
  include TimeoutModule
  belongs_to :member

  attr_accessible :member, :auth_token, :device_id, :apns_token, :gcm_id,
                  :device_os, :device_app_version, :device_app_build,
                  :device_timezone, :device_notifications_enabled, :device_model,
                  :advertiser_id

  validates :member, presence: true
  validates :auth_token, presence: true, uniqueness: true
  validates :apns_token, uniqueness: {scope: :disabled_at}, allow_nil: true
  validates :gcm_id, uniqueness: {scope: :disabled_at}, allow_nil: true

  before_validation :set_auth_token
  before_destroy :unset_notification_tokens

  def store_apns_token!(token)
    if apns_token != token
      transaction do
        self.class.where(apns_token: token).destroy_all
        update_attributes!(apns_token: token)
      end
    end
  end

  def store_gcm_id!(new_gcm_id)
    if gcm_id != new_gcm_id
      transaction do
        self.class.where(gcm_id: new_gcm_id).destroy_all
        update_attributes!(gcm_id: new_gcm_id)
      end
    end
  end

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
