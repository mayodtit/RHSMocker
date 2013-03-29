class CreateSymptomsFactors < ActiveRecord::Migration
  def change
    create_table :symptoms_factors do |t|
      t.boolean :doctor_call_worthy
      t.boolean :er_worthy
      t.references :symptom
      t.references :factor
      t.references :factor_group

      t.timestamps
    end
    add_index :symptoms_factors, :symptom_id
    add_index :symptoms_factors, :factor_id
    add_index :symptoms_factors, :factor_group_id
  end
end
