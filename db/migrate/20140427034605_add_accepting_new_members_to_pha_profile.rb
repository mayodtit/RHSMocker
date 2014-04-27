class AddAcceptingNewMembersToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :accepting_new_members, :boolean
  end
end
