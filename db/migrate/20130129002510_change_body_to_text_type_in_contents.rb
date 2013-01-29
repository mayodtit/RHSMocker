class ChangeBodyToTextTypeInContents < ActiveRecord::Migration
  def up
  	change_column :contents, :body, :text
  end

  def down
  	change_column :contents, :body, :string
  end
end
