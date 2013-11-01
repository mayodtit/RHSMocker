class AddSymptomidtosymptomselfcare < ActiveRecord::Migration
   def change
    add_column :symptom_selfcares, :symptom_id, :integer
  end
end
