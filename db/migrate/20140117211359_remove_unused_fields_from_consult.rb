class RemoveUnusedFieldsFromConsult < ActiveRecord::Migration
  def up
    remove_column :consults, :priority
    remove_column :consults, :checked
  end

  def down
    add_column :consults, :priority, :string
    add_column :consults, :checked, :boolean
  end
end
