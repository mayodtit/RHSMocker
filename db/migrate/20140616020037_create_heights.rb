class CreateHeights < ActiveRecord::Migration
  def change
    create_table :heights do |t|
      t.references :user
      t.decimal :amount, precision: 9, scale: 5
      t.datetime :taken_at
      t.timestamps
    end
  end
end
