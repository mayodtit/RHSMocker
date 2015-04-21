class ChangeZipInProximities < ActiveRecord::Migration
  def up
    change_column :proximities, :zip, :string
  end

  def down
    change_column :proximities, :zip, :integer
  end
end
