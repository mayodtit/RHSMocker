class RenameContentsVocabulariesToContentsMayoVocabulariesTable < ActiveRecord::Migration
  def change
    rename_table :contents_vocabularies, :contents_mayo_vocabularies
  end
end
