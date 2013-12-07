class CreateUserContentLikes < ActiveRecord::Migration
  def change
    create_table :user_content_likes do |t|
      t.references :user
      t.references :content
      t.string     :action
      t.timestamps
    end
  end
end
