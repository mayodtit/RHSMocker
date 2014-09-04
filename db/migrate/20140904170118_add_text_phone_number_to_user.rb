class AddTextPhoneNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :text_phone_number, :string
  end
end
