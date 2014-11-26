class ChangeNuxStoryHtmlColumnSize < ActiveRecord::Migration
  def up
    change_column :nux_stories, :html, :text, limit: 4294967295
  end

  def down
    change_column :nux_stories, :html, :text, limit: 65535
  end
end
