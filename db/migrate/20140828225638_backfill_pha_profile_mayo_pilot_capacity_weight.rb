class BackfillPhaProfileMayoPilotCapacityWeight < ActiveRecord::Migration
  def up
    PhaProfile.reset_column_information
    PhaProfile.update_all(mayo_pilot_capacity_weight: 0)
  end

  def down
  end
end
