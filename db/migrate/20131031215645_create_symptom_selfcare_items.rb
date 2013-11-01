class CreateSymptomSelfcareItems < ActiveRecord::Migration
  def change
    create_table :symptom_selfcare_items do |t|
      t.string :description
      t.references :symptom_selfcare

      t.timestamps
    end
    add_index :symptom_selfcare_items, :symptom_selfcare_id
  end
end
