class AddBetaRole < ActiveRecord::Migration
  def up
    Role.find_or_create_by_name(:beta)
  end

  def down
  end
end
