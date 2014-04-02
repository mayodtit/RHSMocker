class SetSubscriptionEndDateForFriendsAndFamily < ActiveRecord::Migration
  def up
    ids = FeatureGroup.where(premium: true).map(&:users).flatten.map(&:id)
    User.where(id: ids).update_all(subscription_end_Date: DateTime.parse("2014-12-31 11:59:59PM"))
  end

  def down
    ids = FeatureGroup.where(premium: true).map(&:users).flatten.map(&:id)
    User.where(id: ids).update_all(subscription_end_date: nil)
  end
end
