class CreateUserAllergies < ActiveRecord::Migration
  def change
    create_table :user_allergies do |t|
      t.references :user
      t.references :allergy

      t.timestamps
    end
    add_index :user_allergies, :user_id
    add_index :user_allergies, :allergy_id
  end
end
