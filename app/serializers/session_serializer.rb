class SessionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :device_id, :device_os, :device_app_version,
             :device_timezone, :device_notifications_enabled
end
