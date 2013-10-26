class UpdateCardValues < ActiveRecord::Migration
  def up
    Card.where(:state => :unread).update_all(:state => :unsaved)
    Card.where(:state => :read).update_all(:state => :unsaved)
  end

  def down
    Card.where(:state => :unsaved).update_all(:state => :unread)
  end
end
