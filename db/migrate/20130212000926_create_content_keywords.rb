class CreateContentKeywords < ActiveRecord::Migration
  def change
    create_table :content_keywords do |t|
      t.string :name
      t.boolean :default
      
      t.timestamps
    end
  end
end
