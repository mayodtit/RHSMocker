class DropNotes < ActiveRecord::Migration
  def up
    drop_table :notes
  end

  def down
    create_table :notes do |t|
      t.integer :member_id, null: false
      t.integer :creator_id, null: false
      t.text :text, null: false
    end
  end
end
