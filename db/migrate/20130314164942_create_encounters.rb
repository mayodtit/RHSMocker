class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.string :status
      t.string :priority
      t.references :user
      t.boolean :checked

      t.timestamps
    end
    add_index :encounters, :user_id
  end
end
