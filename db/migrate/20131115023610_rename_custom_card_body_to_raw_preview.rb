class RenameCustomCardBodyToRawPreview < ActiveRecord::Migration
  def up
    rename_column :custom_cards, :body, :raw_preview
  end

  def down
    rename_column :custom_cards, :raw_preview, :body
  end
end
