class ChangeTypeContentIdOnAuthorsContents < ActiveRecord::Migration
  def up
    change_column :authors_contents, :content_id, :string
  end

  def down
    change_column :authors_contents, :content_id, :integer
  end
end
