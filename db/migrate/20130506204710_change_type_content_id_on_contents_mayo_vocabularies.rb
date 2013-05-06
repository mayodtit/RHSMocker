class ChangeTypeContentIdOnContentsMayoVocabularies < ActiveRecord::Migration
  def up
    change_column :contents_mayo_vocabularies, :content_id, :string
  end

  def down
    change_column :contents_mayo_vocabularies, :content_id, :integer
  end
end
