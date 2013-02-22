class CreateContentVocabularies < ActiveRecord::Migration
  def change
    create_table :content_vocabularies do |t|
      t.integer :content_id
      t.integer :mayo_vocabulary_id
      t.timestamps
    end
  end
end



