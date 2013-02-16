class ChangeFieldsOfContents < ActiveRecord::Migration
  def up
  	rename_column :contents, :headline, :title
  	add_column :contents, :abstract, :text
  	add_column :contents, :question, :text
  end

  def down
  	rename_column :contents, :title, :headline
  	remove_column :contents, :abstract
  	remove_column :contents, :question
  end
end
