class CreateUserInformations < ActiveRecord::Migration
  def change
    create_table :user_informations do |t|
      t.references :user
      t.timestamps
    end
  end
end
