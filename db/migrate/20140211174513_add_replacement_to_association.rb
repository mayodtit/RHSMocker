class AddReplacementToAssociation < ActiveRecord::Migration
  def change
    add_column :associations, :replacement_id, :integer
  end
end
