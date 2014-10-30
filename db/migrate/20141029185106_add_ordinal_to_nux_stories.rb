class AddOrdinalToNuxStories < ActiveRecord::Migration
  def change
    add_column :nux_stories, :ordinal, :integer
  end
end
