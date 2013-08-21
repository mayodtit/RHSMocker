class AddFieldsToPhoneCall < ActiveRecord::Migration
  def change
    add_column :phone_calls, :origin_phone_number, :string
    add_column :phone_calls, :destination_phone_number, :string
  end
end
