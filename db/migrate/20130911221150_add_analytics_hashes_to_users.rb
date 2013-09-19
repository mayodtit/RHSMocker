class AddAnalyticsHashesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :mixpanel_uuid, :string, limit: 36
    add_column :users, :google_analytics_uuid, :string, limit: 36
    User.all.each do |u|
      u.send(:create_analytics_uuids)
      u.save!
    end
  end

  def down
    remove_column :users, :mixpanel_uuid, :string, limit: 36
    remove_column :users, :google_analytics_uuid, :string, limit: 36
  end
end
