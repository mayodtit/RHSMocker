class PublishCurrentContent < ActiveRecord::Migration
  def up
    Content.update_all(:state => :published)
  end

  def down
  end
end
