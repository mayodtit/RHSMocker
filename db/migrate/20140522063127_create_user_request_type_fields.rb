class CreateUserRequestTypeFields < ActiveRecord::Migration
  def change
    create_table :user_request_type_fields do |t|
      t.references :user_request_type
      t.string :name
      t.string :type
      t.integer :ordinal
      t.timestamps
    end
  end
end
