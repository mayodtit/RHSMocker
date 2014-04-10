class AddHighlightsToUserInformation < ActiveRecord::Migration
  def change
    add_column :user_informations, :highlights, :text
  end
end
