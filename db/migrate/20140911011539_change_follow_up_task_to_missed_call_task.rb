class ChangeFollowUpTaskToMissedCallTask < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    puts "Updating #{ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM `tasks` WHERE `tasks`.`type` = 'FollowUpTask'").first[0]} rows"
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `tasks`.`type` = 'MissedCallTask' WHERE `tasks`.`type` = 'FollowUpTask'"
  end

  def down
    ActiveRecord::Base.establish_connection
    puts "Updating #{ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM `tasks` WHERE `tasks`.`type` = 'MissedCallTask'").first[0]} rows"
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `tasks`.`type` = 'FollowUpTask' WHERE `tasks`.`type` = 'MissedCallTask'"
  end
end
