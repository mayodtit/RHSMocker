class AddHealthkitUuidToModels < ActiveRecord::Migration
  def change
    add_column :heights, :healthkit_uuid, :string
    add_column :weights, :healthkit_uuid, :string
    add_column :blood_pressures, :healthkit_uuid, :string
  end
end
