class AddTitleToTaskGuides < ActiveRecord::Migration
  def change
    add_column :task_guides, :title, :string
  end
end
