class SetPriorityOnInboundTasks < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `priority` = 10 WHERE `type` = 'PhoneCallTask'"
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `priority` = 5 WHERE `type` = 'MessageTask'"
  end

  def down
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `priority` = 0 WHERE `type` = 'PhoneCallTask' OR `type` = 'MessageTask'"
  end
end
