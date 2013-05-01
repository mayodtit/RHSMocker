class AddIndexToContent < ActiveRecord::Migration
  def change
  	add_index :contents, :mayo_doc_id
  end
end
