class UpdateCreatorForAssociations < ActiveRecord::Migration
  def up
    Association.where(creator_id: nil).each do |association|
      association.update_attribute(:creator_id, association.user_id)
    end
  end

  def down
  end
end
