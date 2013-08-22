class ChangeDatesOnCard < ActiveRecord::Migration
  def up
    add_column :cards, :state_changed_at, :datetime
    Card.where(:state => :read).update_all('state_changed_at = read_at')
    Card.where(:state => :saved).update_all('state_changed_at = saved_at')
    Card.where(:state => :dismissed).update_all('state_changed_at = dismissed_at')
    remove_column :cards, :read_at
    remove_column :cards, :saved_at
    remove_column :cards, :dismissed_at
  end

  def down
    add_column :cards, :read_at, :datetime
    add_column :cards, :saved_at, :datetime
    add_column :cards, :dismissed_at, :datetime
    Card.where(:state => :read).update_all('read_at = state_changed_at')
    Card.where(:state => :saved).update_all('saved_at = state_changed_at')
    Card.where(:state => :dismissed).update_all('dismissed_at = state_changed_at')
    remove_column :cards, :state_changed_at
  end
end
