class AddIndexPhoneCallIdOnUserOfferings < ActiveRecord::Migration
  def change
  	add_index :user_offerings, :phone_call_id
  end
end
