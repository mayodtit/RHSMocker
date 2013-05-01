class AddMayoDocIdToContent < ActiveRecord::Migration
  def change
    add_column :contents, :mayo_doc_id, :string
  end
end
