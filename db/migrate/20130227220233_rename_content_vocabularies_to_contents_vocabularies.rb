class RenameContentVocabulariesToContentsVocabularies < ActiveRecord::Migration
  def change
    rename_table :content_vocabularies, :contents_vocabularies
  end
end
