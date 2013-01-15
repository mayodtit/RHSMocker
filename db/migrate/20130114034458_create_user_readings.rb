class CreateUserReadings < ActiveRecord::Migration
  def change
    create_table :user_readings do |t|
      t.datetime :completed_date
      t.integer :user_id
      t.integer :content_id

      t.timestamps
    end
  end
end
