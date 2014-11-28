class AddHealthkitSourceToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :healthkit_source, :string
  end
end
