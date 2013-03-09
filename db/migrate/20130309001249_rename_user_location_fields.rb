class RenameUserLocationFields < ActiveRecord::Migration
  def change
    rename_column :user_locations, :long, :longitude
    rename_column :user_locations, :lat, :latitude
  end
end
