class ChangeTypeContentIdOnContentsSymptomsFactors < ActiveRecord::Migration
  def up
    change_column :contents_symptoms_factors, :content_id, :string
  end

  def down
    change_column :contents_symptoms_factors, :content_id, :integer
  end
end
