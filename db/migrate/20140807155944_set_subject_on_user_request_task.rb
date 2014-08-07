class SetSubjectOnUserRequestTask < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` JOIN `user_requests` ON `tasks`.`type` = 'UserRequestTask' AND `user_requests`.`id` = `tasks`.`user_request_id` SET `tasks`.`subject_id` = `user_requests`.`subject_id`"
  end

  def down
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `tasks`.`subject_id` = NULL WHERE `tasks`.`type` = 'UserRequestTask'"
  end
end
