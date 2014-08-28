class RemoveMayoPilotFromPhaProfile < ActiveRecord::Migration
  def up
    remove_column :pha_profiles, :mayo_pilot
  end

  def down
    add_column :pha_profiles, :mayo_pilot, :boolean
  end
end
