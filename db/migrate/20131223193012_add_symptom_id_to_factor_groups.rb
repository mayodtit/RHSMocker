class AddSymptomIdToFactorGroups < ActiveRecord::Migration
  def change
    add_column :factor_groups, :symptom_id, :integer
  end
end
