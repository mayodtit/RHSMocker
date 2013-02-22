class CreateMayoVocabularies < ActiveRecord::Migration
  def change
    create_table :mayo_vocabularies do |t|
 		t.string :mcvid
      t.string :title
      t.timestamps
    end
  end
end
