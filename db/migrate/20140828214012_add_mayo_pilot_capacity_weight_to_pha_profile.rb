class AddMayoPilotCapacityWeightToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :mayo_pilot_capacity_weight, :integer
  end
end
