class AddEnableWebviewScrollingToNuxStory < ActiveRecord::Migration
  def change
    add_column :nux_stories, :enable_webview_scrolling, :boolean
  end
end
