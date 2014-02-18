class AddTypeToAssociations < ActiveRecord::Migration
  def change
    add_column :associations, :type, :string
  end
end
