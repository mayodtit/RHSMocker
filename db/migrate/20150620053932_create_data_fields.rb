class CreateDataFields < ActiveRecord::Migration
  def change
    create_table :data_fields do |t|
      t.references :service
      t.references :data_field_template
      t.text :data
      t.timestamps
    end
  end
end
