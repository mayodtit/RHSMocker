class AddDataToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :data, :text
  end
end
