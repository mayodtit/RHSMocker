class CreateMayoVocabulariesMessagesTable < ActiveRecord::Migration
  def change
    create_table :mayo_vocabularies_messages do |t|
      t.integer :mayo_vocabulary_id
      t.integer :message_id

      t.timestamps
    end
  end
end
