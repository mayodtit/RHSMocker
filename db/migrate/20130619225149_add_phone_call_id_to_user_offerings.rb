class AddPhoneCallIdToUserOfferings < ActiveRecord::Migration
  def change
    add_column :user_offerings, :phone_call_id, :integer
  end
end
