class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
	  t.integer :user_id
      t.decimal :lat, :precision => 10, :scale => 6
      t.decimal :long, :precision => 10, :scale => 6
      t.timestamps
    end
  end
end
