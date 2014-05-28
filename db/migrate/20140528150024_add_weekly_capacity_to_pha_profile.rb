class AddWeeklyCapacityToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :weekly_capacity, :integer
  end
end
