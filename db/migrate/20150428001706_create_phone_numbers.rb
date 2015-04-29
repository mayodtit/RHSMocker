class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string  :type
      t.string  :number
      t.references :phoneable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
