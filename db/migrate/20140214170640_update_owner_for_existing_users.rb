class UpdateOwnerForExistingUsers < ActiveRecord::Migration
  def up
    # all members own themselves
    Member.all.each do |member|
      member.update_attribute(:owner, member)
    end

    # all users with a single inverse_association are owned by the
    # association's originating user
    associate_ids = User.joins(:inverse_associations)
                        .where("users.type != 'Member'")
                        .group(:associate_id)
                        .count.reject{|k,v| v != 1}.keys
    Association.where(associate_id: associate_ids)
               .includes(:associate).each do |association|
      association.associate.update_attribute(:owner_id, association.user_id)
    end

    # all remaining users own themselves
    User.where(owner_id: nil).each do |user|
      user.update_attribute(:owner, user)
    end
  end

  def down
  end
end
