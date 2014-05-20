class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :service_types, :name, unique: true
  end
end
