class CreateProximities < ActiveRecord::Migration
  def up
    create_table :proximity do |t|
      t.string :city
      t.integer :zip
      t.string :state
      t.string :county
      t.float :latitude
      t.float :longitude
    end
  end
  def down
    drop_table :proximity
  end
end