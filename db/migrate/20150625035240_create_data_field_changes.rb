class CreateDataFieldChanges < ActiveRecord::Migration
  def change
    create_table :data_field_changes do |t|
      t.references :data_field
      t.references :actor
      t.text :data
      t.timestamps
    end
  end
end
