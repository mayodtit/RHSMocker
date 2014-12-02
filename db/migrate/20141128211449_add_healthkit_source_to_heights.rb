class AddHealthkitSourceToHeights < ActiveRecord::Migration
  def change
    add_column :heights, :healthkit_source, :string
  end
end
