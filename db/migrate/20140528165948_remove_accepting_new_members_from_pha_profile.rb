class RemoveAcceptingNewMembersFromPhaProfile < ActiveRecord::Migration
  def up
    remove_column :pha_profiles, :accepting_new_members
  end

  def down
    add_column :pha_profiles, :accepting_new_members, :boolean
  end
end
