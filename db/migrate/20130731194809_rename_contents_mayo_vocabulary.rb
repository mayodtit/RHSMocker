class RenameContentsMayoVocabulary < ActiveRecord::Migration
  def up
    rename_table :contents_mayo_vocabularies, :content_mayo_vocabularies
  end

  def down
    rename_table :content_mayo_vocabularies, :contents_mayo_vocabularies
  end
end
