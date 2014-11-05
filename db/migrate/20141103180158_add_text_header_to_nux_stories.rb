class AddTextHeaderToNuxStories < ActiveRecord::Migration
  def change
    add_column :nux_stories, :text_header, :text
  end
end
