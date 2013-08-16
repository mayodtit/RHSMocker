class CreateUserDiseaseUserTreatments < ActiveRecord::Migration
  def change
    create_table :user_disease_user_treatments do |t|
      t.references :user_disease, null: false
      t.references :user_disease_treatment, null: false
      t.timestamps
    end
  end
end
