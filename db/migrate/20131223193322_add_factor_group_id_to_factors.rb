class AddFactorGroupIdToFactors < ActiveRecord::Migration
  def change
    add_column :factors, :factor_group_id, :integer
  end
end
