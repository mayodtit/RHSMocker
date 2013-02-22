class CreateMayoVocabulary < ActiveRecord::Migration
  def change
    create_table :mayo_vocabulary do |t|
      t.string :mcvid
      t.string :title

      t.timestamps
    end
  end
end
