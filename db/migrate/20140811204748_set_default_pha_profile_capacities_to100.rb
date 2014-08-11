class SetDefaultPhaProfileCapacitiesTo100 < ActiveRecord::Migration
  def up
    PhaProfile.reset_column_information
    PhaProfile.update_all(capacity_weight: 100)
  end

  def down
  end
end
