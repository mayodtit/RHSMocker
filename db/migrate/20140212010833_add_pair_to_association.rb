class AddPairToAssociation < ActiveRecord::Migration
  def change
    add_column :associations, :pair_id, :integer
  end
end
