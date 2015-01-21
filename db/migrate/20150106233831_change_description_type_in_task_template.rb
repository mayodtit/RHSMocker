class ChangeDescriptionTypeInTaskTemplate < ActiveRecord::Migration
  def up
    change_column :task_templates, :description, :text
  end
  def down
    change_column :task_templates, :description, :string
  end
end
