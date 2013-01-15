class AddTypeAndCompleteDateToContent < ActiveRecord::Migration
  def change
    add_column :contents, :contentsType, :string
  end
end
