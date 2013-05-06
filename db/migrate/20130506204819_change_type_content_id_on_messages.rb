class ChangeTypeContentIdOnMessages < ActiveRecord::Migration
  def up
    change_column :messages, :content_id, :string
  end

  def down
    change_column :messages, :content_id, :integer
  end
end
