class CreateUserOfferings < ActiveRecord::Migration
  def change
    create_table :user_offerings do |t|
      t.references :offering
      t.references :user

      t.timestamps
    end
    add_index :user_offerings, :offering_id
    add_index :user_offerings, :user_id
  end
end
