class RemoveContentKeywordsTable < ActiveRecord::Migration
  def change
    drop_table :content_keywords
  end
end
