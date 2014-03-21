class BackfillParentAssociations < ActiveRecord::Migration
  def up
    Association.joins(:user, :associate)
               .where('users.id = users.owner_id')
               .where("associates_associations.id != associates_associations.owner_id")
               .where('associates_associations.owner_id != users.id')
               .readonly(false).each do |a|
                 a.update_attributes(parent: Association.where(user_id: a.associate.owner_id, associate_id: a.user_id).first!)
               end
  end

  def down
  end
end
