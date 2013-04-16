class ChangeNoteColumnOnFeedbacks < ActiveRecord::Migration
  def up
    change_column :feedbacks, :note, :text
  end

  def down
    change_column :feedbacks, :note, :string
  end
end
