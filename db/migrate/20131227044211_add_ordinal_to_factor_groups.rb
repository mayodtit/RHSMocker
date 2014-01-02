class AddOrdinalToFactorGroups < ActiveRecord::Migration
  def change
    add_column :factor_groups, :ordinal, :integer
  end
end
