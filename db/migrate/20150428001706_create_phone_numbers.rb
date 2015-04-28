class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :type
      t.string :number
      t.integer :user_id
      t.integer :address_id

      t.timestamps
    end
  end
end
