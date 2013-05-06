class AddTakenAtToBloodPressures < ActiveRecord::Migration
  def change
    add_column :blood_pressures, :taken_at, :datetime
  end
end
