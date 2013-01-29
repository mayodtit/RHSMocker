class RenameTextInContents < ActiveRecord::Migration
  def up
  	rename_column :contents, :text, :body
  end

  def down
  	rename_column :contents, :body, :text
  end
end