class CreateUserPromotions < ActiveRecord::Migration
  def change
    create_table :user_promotions do |t|
      t.references :user
      t.references :promotion
      
      t.timestamps
    end
    add_index :user_promotions, :user_id
    add_index :user_promotions, :promotion_id
  end
end
