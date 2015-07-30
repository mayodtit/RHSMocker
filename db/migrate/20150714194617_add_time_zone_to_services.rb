class AddTimeZoneToServices < ActiveRecord::Migration
  def change
    add_column :services, :time_zone, :string
  end
end
