class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.references :user
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.timestamps
    end
  end
end
