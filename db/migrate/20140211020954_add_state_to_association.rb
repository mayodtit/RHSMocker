class AddStateToAssociation < ActiveRecord::Migration
  def change
    add_column :associations, :state, :string
  end
end
