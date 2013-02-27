class CreateAuthorsContentsTable < ActiveRecord::Migration
   def change
    create_table :authors_contents do |t|
      t.integer :author_id
      t.integer :content_id

      t.timestamps
    end
  end
end
