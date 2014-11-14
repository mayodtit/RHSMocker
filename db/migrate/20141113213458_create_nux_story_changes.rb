class CreateNuxStoryChanges < ActiveRecord::Migration
  def change
    create_table :nux_story_changes do |t|
      t.references :nux_story
      t.text :data
      t.timestamps
    end
  end
end
