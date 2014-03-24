class AddAllowTosChecked < ActiveRecord::Migration
  def up
    Metadata.find_or_create_by_mkey(mkey: 'allow_tos_checked', mvalue: 'true')
  end

  def down
  end
end
