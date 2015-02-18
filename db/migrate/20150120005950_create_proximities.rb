class CreateProximities < ActiveRecord::Migration
  def change
    create_table :proximities do |t|
      t.string :city
      t.integer :zip
      t.string :state
      t.string :county
      t.float :latitude
      t.float :longitude
    end
  end
end