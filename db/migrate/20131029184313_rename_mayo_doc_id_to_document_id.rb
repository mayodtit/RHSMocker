class RenameMayoDocIdToDocumentId < ActiveRecord::Migration
  def up
    remove_index :contents, :mayo_doc_id
    rename_column :contents, :mayo_doc_id, :document_id
    add_index :contents, :document_id
  end

  def down
    remove_index :contents, :document_id
    rename_column :contents, :document_id, :mayo_doc_id
    add_index :contents, :mayo_doc_id
  end
end
