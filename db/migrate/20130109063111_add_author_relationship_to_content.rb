class AddAuthorRelationshipToContent < ActiveRecord::Migration
  def change
    add_column :contents, :author_id, :integer
  end
end
