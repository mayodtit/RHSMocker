class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.timestamps
      t.integer :member_id, null: false
      t.integer :resource_id, null: false
      t.string :resource_type, null: false
    end

    add_index :entries, [:resource_id, :resource_type]
    add_index :entries, :member_id
  end
end
