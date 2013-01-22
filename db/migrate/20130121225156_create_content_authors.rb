class CreateContentAuthors < ActiveRecord::Migration
  def change
    create_table :content_authors do |t|
      t.integer :user_id
      t.integer :content_id

      t.timestamps
    end
  end
end
