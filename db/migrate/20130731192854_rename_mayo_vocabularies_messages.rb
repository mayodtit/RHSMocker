class RenameMayoVocabulariesMessages < ActiveRecord::Migration
  def up
    rename_table :mayo_vocabularies_messages, :message_mayo_vocabularies
  end

  def down
    rename_table :message_mayo_vocabularies, :mayo_vocabularies_messages
  end
end
