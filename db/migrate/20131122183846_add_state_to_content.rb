class AddStateToContent < ActiveRecord::Migration
  def change
    add_column :contents, :state, :string
  end
end
