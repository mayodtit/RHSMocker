class AddIdentifierTokenToPhoneCall < ActiveRecord::Migration
  def change
    add_column :phone_calls, :identifier_token, :string
    add_index :phone_calls, :identifier_token
  end
end
