class AddTimeZoneOffsetToServices < ActiveRecord::Migration
  def change
    add_column :services, :time_zone_offset, :integer
  end
end
