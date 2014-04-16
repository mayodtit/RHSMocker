class AddPreviewImageUrlToContent < ActiveRecord::Migration
  def change
    add_column :contents, :preview_image_url, :string
  end
end
