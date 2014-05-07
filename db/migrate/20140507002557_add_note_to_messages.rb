class AddNoteToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :note, :boolean, default: false, null: false
    add_index :messages, [:consult_id, :created_at, :note]
  end
end
