class AddTextFooterToNuxStories < ActiveRecord::Migration
  def change
    add_column :nux_stories, :text_footer, :text
  end
end
