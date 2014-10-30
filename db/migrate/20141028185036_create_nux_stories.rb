class CreateNuxStories < ActiveRecord::Migration
  def change
    create_table :nux_stories do |t|
      t.text :html
      t.string :action_button_text
      t.boolean :show_nav_signup
      t.timestamps
    end
  end
end
