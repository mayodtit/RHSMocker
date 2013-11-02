class CreateSymptomSelfcares < ActiveRecord::Migration
  def change
    create_table :symptom_selfcares do |t|
      t.text :description

      t.timestamps
    end
  end
end
