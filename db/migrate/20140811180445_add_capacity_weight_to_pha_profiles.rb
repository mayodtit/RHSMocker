class AddCapacityWeightToPhaProfiles < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :capacity_weight, :integer
  end
end
