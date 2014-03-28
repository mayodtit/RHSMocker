class MarkMembersAsPremium < ActiveRecord::Migration
  def up
    ids = FeatureGroup.where(premium: true).map(&:users).flatten.map(&:id)
    User.where(id: ids).update_all(is_premium: true)
    Member.where('email LIKE "%@getbetter.com"').update_all(is_premium: true)
  end

  def down
    User.update_all(is_premium: false)
  end
end
