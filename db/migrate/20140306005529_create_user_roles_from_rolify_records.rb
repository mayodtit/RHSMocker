class CreateUserRolesFromRolifyRecords < ActiveRecord::Migration
  def up
    connection.execute('SELECT user_id, role_id FROM users_roles').each(as: :hash) do |row|
      ur = UserRole.create(user_id: row['user_id'], role_id: row['role_id'])
      if ur.errors.any?
        puts "*****ERROR*****: user_id: #{ur.user_id}, role_id: #{ur.role_id}, #{ur.errors.full_messages.to_sentence}"
      end
    end
  end

  def down
  end
end
