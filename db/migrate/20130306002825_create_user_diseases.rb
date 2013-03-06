class CreateUserDiseases < ActiveRecord::Migration
  def change
    create_table :user_diseases do |t|
      t.references :user
      t.references :disease
      t.date :start_date
      t.date :end_date
      t.boolean :being_treated
      t.boolean :diagnosed

      t.timestamps
    end
    add_index :user_diseases, :user_id
    add_index :user_diseases, :disease_id
  end
end
