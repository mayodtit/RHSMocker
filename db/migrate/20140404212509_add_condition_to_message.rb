class AddConditionToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :condition_id, :integer
  end
end
