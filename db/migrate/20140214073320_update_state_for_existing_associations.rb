class UpdateStateForExistingAssociations < ActiveRecord::Migration
  def up
    Association.update_all(state: 'enabled')
  end

  def down
  end
end
