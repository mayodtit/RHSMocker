class AddKeywordsToContent < ActiveRecord::Migration
  def change
    add_column :contents, :keywords, :text 
  end
end
