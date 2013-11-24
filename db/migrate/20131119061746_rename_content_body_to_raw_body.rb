class RenameContentBodyToRawBody < ActiveRecord::Migration
  def up
    rename_column :contents, :body, :raw_body
  end

  def down
    rename_column :contents, :raw_body, :body
  end
end
