class AddRawPreviewToContent < ActiveRecord::Migration
  def change
    add_column :contents, :raw_preview, :text
  end
end
