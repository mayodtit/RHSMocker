class MigrateTasksToNewStates < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `state` = 'unstarted' WHERE `state` = 'unassigned' OR `state` = 'assigned'"
  end

  def down
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `state` = 'unassigned' WHERE `state` = 'unstarted' AND owner_id IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `state` = 'assigned' WHERE `state` = 'unstarted' AND owner_id IS NOT NULL"
  end
end
