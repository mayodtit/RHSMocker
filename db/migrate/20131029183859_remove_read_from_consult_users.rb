class RemoveReadFromConsultUsers < ActiveRecord::Migration
  def up
    remove_column :consult_users, :read
  end

  def down
    add_column :consult_users, :read, :boolean
  end
end
