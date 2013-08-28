class RemoveAuthors < ActiveRecord::Migration
  def up
    drop_table :authors
    drop_table :authors_contents
  end

  def down
    create_table "authors", :force => true do |t|
      t.string   "name"
      t.string   "image_url"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "short_name"
    end

    create_table "authors_contents", :force => true do |t|
      t.integer  "author_id"
      t.integer  "content_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
