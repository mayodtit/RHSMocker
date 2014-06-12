class FixAssignorForTasks < ActiveRecord::Migration
  def up
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute "UPDATE `tasks` SET `assignor_id` = #{Member.robot.id}, `assigned_at` = '#{Time.now.to_s(:db)}' WHERE `owner_id` IS NOT NULL AND `assignor_id` IS NULL"
  end

  def down
    # Do nothing
  end
end
