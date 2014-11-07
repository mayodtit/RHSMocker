class AddEnabledToNuxStory < ActiveRecord::Migration
  def change
    add_column :nux_stories, :enabled, :boolean
  end
end
