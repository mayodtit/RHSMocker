class AddSymptomIdToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :symptom_id, :integer
  end
end
