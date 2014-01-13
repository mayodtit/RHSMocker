class AddWorkPhoneNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :work_phone_number, :string
  end
end
