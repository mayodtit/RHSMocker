class AddMayoPilotToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :mayo_pilot, :boolean
  end
end
