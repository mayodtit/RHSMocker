class BackfillPhaProfileAcceptingNewMembers < ActiveRecord::Migration
  def up
    PhaProfile.reset_column_information
    %w(clare@getbetter.com lauren@getbetter.com meg@getbetter.com
       ninette@getbetter.com).each do |email|
      Member.find_by_email(email).try(:pha_profile).try(:update_attributes, accepting_new_members: true)
    end
  end

  def down
  end
end
