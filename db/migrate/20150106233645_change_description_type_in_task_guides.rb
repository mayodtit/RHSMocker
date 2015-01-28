class ChangeDescriptionTypeInTaskGuides < ActiveRecord::Migration
  def up
    change_column :task_guides, :description, :text
  end
  def down
    change_column :task_guides, :description, :string
  end
end
