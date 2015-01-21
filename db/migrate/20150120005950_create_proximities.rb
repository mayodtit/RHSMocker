class CreateProximities < ActiveRecord::Migration
  def change
    create_table :proximity do |t|
      t.string :city
      t.integer :zip
      t.string :state
      t.string :county
      t.decimal :latitude
      t.decimal :longitude
    end
  end
end