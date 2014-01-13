class AddPhaLeadRole < ActiveRecord::Migration
  def up
    Role.find_or_create_by_name! 'pha_lead'
  end

  def down
    Role.find_by_name!('pha_lead').destroy
  end
end
