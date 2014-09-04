class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.timestamp :started_at
      t.timestamp :ended_at
      t.integer :total_users
      t.integer :users_with_message
      t.integer :users_with_service
      t.integer :converted_users
      t.text :raw_data
      t.timestamps
    end
  end
end
