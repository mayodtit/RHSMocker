class ConvertOffHoursMessagestoSystemMessages < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `messages` SET `messages`.`system` = 1 WHERE `messages`.`off_hours` = 1"
  end

  def down
  end
end
