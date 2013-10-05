class CreateUserContentLikes < ActiveRecord::Migration
  def change
    create_table :user_content_likes do |t|
      t.references :user
      t.references :content
      t.integer    :action
      t.timestamps
    end
  end
end
