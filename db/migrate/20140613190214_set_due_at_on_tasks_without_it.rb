class SetDueAtOnTasksWithoutIt < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `due_at` = '#{Time.now.to_s(:db)}' WHERE `due_at` IS NULL"
  end

  def down
    # Do nothing
  end
end
