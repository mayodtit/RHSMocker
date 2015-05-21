class DropPhoneFieldsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :phone
    remove_column :users, :work_phone_number
    remove_column :users, :text_phone_number
  end

  def down
    add_column :users, :phone, :string
    add_column :users, :work_phone_number, :string
    add_column :users, :text_phone_number, :string

    User.reset_column_information

    ## Restore phone numbers column values from PhoneNumber objects
    User.includes(:phone_numbers).find_each do |user|
      user.phone = user.phone_obj.try(:number)
      user.work_phone_number = user.work_phone_number_obj.try(:number)
      user.text_phone_number = user.text_phone_number_obj.try(:number)
      user.save
    end
  end
end
