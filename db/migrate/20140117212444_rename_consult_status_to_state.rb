class RenameConsultStatusToState < ActiveRecord::Migration
  def up
    rename_column :consults, :status, :state
  end

  def down
    rename_column :consults, :state, :status
  end
end
