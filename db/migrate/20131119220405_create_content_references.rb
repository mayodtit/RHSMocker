class CreateContentReferences < ActiveRecord::Migration
  def change
    create_table :content_references do |t|
      t.integer :referrer_id
      t.integer :referee_id
      t.timestamps
    end
  end
end
