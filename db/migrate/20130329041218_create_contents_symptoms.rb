class CreateContentsSymptoms < ActiveRecord::Migration
  def change
  	create_table :contents_symptoms do |t|
  		t.references :content
  		t.references :symptom

  		t.timestamps
  	end
  	add_index :contents_symptoms, :content_id
  	add_index :contents_symptoms, :symptom_id
  end
end
