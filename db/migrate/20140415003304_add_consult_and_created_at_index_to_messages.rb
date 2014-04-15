class AddConsultAndCreatedAtIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, [:consult_id, :created_at]
  end
end
