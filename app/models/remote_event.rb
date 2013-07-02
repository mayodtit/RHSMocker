class RemoteEvent < ActiveRecord::Base
  attr_accessible :name, :device_created_at, :device_language, :device_os, :device_os_version,
                  :device_model, :device_timezone_offset, :app_version, :app_build

  validates :name, :device_created_at, :device_language, :device_os, :device_os_version,
            :device_model, :device_timezone_offset, :app_version, :app_build, presence: true
end
