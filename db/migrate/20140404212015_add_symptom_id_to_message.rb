class AddSymptomIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :symptom_id, :integer
  end
end
