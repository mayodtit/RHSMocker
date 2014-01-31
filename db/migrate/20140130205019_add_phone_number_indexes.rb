class AddPhoneNumberIndexes < ActiveRecord::Migration
  def change
    add_index :phone_calls, :origin_phone_number
    add_index :phone_calls, [:state, :origin_phone_number]
    add_index :users, :phone
  end
end
