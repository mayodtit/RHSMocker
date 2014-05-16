class RemovePersonalHealthAssistantAssociationType < ActiveRecord::Migration
  def up
    pha_type = AssociationType.find_by_name('Personal Health Assistant')
    if pha_type
      care_provider_type = AssociationType.find_by_name('Care Provider')
      if care_provider_type
        Association.where(association_type_id: pha_type.id)
                   .update_all(association_type_id: care_provider_type.id)
      else
        Association.where(association_type_id: pha_type.id).destroy_all
      end
      pha_type.destroy
    end
  end

  def down
    AssociationType.find_or_create_by_name!(name: 'Personal Health Assistant',
                                            relationship_type: 'hcp')
  end
end
