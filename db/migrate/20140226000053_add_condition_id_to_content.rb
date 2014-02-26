class AddConditionIdToContent < ActiveRecord::Migration
  def change
    add_column :contents, :condition_id, :integer
  end
end
