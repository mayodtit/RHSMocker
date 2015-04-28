class AddColumnInWeights < ActiveRecord::Migration
  def up
    add_column :weights, :warning_color, :string
  end

  def down
    remove_column :weights, :warning_color
  end
end
