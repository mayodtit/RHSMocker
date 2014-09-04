class SetTextPhoneNumberFromWorkPhoneNumber < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `users` SET `users`.`text_phone_number` = `users`.`work_phone_number` WHERE `users`.`work_phone_number` IS NOT NULL"
  end

  def down
  end
end
