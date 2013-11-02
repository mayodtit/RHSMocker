class ChangeBodyColumnOnContentsTable < ActiveRecord::Migration
  def up
    change_column :contents, :body, :text, null: true, default: nil
  end

  def down
    change_column :contents, :body, :text, null: false, default: ''
  end
end
