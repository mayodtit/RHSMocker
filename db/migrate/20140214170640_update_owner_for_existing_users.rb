class UpdateOwnerForExistingUsers < ActiveRecord::Migration
  def up
    # all members own themselves
    Member.all.each do |member|
      member.update_attribute(:owner, member)
    end

    # all hcp associations own themselves
    User.joins(:inverse_associations => :association_type)
        .readonly(false)
        .where(:association_types => {relationship_type: :hcp}).each do |user|
      user.update_attribute(:owner, user)
    end

    # all family member associates are owned by the origin user
    Association.joins(:association_type)
               .readonly(false)
               .where(association_types: {relationship_type: :family}).each do |association|
      association.associate.update_attribute(:owner, association.user)
    end

    # all remaining users own themselves
    User.where(owner_id: nil).each do |user|
      user.update_attribute(:owner, user)
    end
  end

  def down
    User.update_all(:owner_id => nil)
  end
end
