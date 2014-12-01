class AddHealthkitSourceToBloodPressures < ActiveRecord::Migration
  def change
    add_column :blood_pressures, :healthkit_source, :string
  end
end
