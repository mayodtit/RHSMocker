class SetConversationStateOnExistingConsults < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `consults` SET `consults`.`conversation_state` = 'inactive' WHERE `consults`.`conversation_state` IS NULL"
  end

  def down
  end
end
