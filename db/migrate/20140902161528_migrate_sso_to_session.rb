class MigrateSsoToSession < ActiveRecord::Migration
  def up
    Member.find_each do |m|
      if m.auth_token
        m.sessions.create!(auth_token: m.auth_token,
                           device_id: m.install_id,
                           apns_token: m.apns_token,
                           gcm_id: m.gcm_id,
                           device_os: m.device_os,
                           device_app_version: m.device_app_version,
                           device_app_build: m.device_app_build,
                           device_timezone: m.device_timezone,
                           device_notifications_enabled: m.device_notifications_enabled)
      end
    end
  end

  def down
  end
end
