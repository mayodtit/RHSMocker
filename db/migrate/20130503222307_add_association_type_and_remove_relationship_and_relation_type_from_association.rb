class AddAssociationTypeAndRemoveRelationshipAndRelationTypeFromAssociation < ActiveRecord::Migration
  def up
    add_column :associations, :association_type_id, :integer
    remove_column :associations, :relation
    remove_column :associations, :relation_type
  end

  def down
  	remove_column :associations, :association_type_id
    add_column :associations, :relation, :string
    add_column :associations, :relation_type, :string
  end
end
