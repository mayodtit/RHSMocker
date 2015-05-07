class AddRefereeIdToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :referee_id, :integer
  end
end
