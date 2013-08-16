class RenameCamelcaseFields < ActiveRecord::Migration
  def up
    rename_column :contents, :contentsType, :content_type
    rename_column :contents, :updateDate, :content_updated_at
  end

  def down
    rename_column :contents, :content_type, :contentsType
    rename_column :contents, :content_updated_at, :updateDate
  end
end
