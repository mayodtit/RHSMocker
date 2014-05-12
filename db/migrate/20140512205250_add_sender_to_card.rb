class AddSenderToCard < ActiveRecord::Migration
  def change
    add_column :cards, :sender_id, :integer
  end
end
