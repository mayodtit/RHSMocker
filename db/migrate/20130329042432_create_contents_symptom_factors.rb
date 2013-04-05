class CreateContentsSymptomFactors < ActiveRecord::Migration
  def change
  	create_table :contents_symptom_factors do |t|
  		t.references :content
  		t.references :symptom_factor

  		t.timestamps
  	end
  	add_index :contents_symptom_factors, :content_id
  	add_index :contents_symptom_factors, :symptom_factor_id
  end
end
