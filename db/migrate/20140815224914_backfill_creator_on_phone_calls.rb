class BackfillCreatorOnPhoneCalls < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `phone_calls` SET `phone_calls`.`creator_id` = `phone_calls`.`user_id` WHERE `phone_calls`.`creator_id` = NULL"
  end

  def down
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `phone_calls` SET `phone_calls`.`creator_id` = NULL"
  end
end
