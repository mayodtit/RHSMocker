class RemoveTypeFromAgreement < ActiveRecord::Migration
  def up
    remove_column :agreements, :type
  end

  def down
    add_column :agreements, :type, :string
  end
end
