class SetUserTimeZoneFromDeviceTimezone < ActiveRecord::Migration
  def up
    Member.reset_column_information
    Member.update_all('time_zone = device_timezone')
  end

  def down
  end
end
