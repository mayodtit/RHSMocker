class RenameOtherFamilyMemberAssociationType < ActiveRecord::Migration
  def up
    AssociationType.find_by_name('Other Family Member').try(:update_attributes, name: 'Family Member')
  end

  def down
    AssociationType.find_by_name('Family Member').try(:update_attributes, name: 'Other Family Member')
  end
end
