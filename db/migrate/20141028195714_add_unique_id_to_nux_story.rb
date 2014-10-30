class AddUniqueIdToNuxStory < ActiveRecord::Migration
  def change
    add_column :nux_stories, :unique_id, :string
  end
end
