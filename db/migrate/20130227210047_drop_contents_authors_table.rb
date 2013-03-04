class DropContentsAuthorsTable < ActiveRecord::Migration
  def change
    drop_table :content_authors
  end

end
