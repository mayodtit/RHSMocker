class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :gender
      t.date :birthDate

      t.timestamps
    end
  end
end
