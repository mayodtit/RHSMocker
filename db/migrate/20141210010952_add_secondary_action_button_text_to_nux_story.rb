class AddSecondaryActionButtonTextToNuxStory < ActiveRecord::Migration
  def change
    add_column :nux_stories, :secondary_action_button_text, :string
  end
end
