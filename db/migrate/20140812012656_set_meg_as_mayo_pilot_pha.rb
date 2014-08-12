class SetMegAsMayoPilotPha < ActiveRecord::Migration
  def up
    Member.reset_column_information
    PhaProfile.reset_column_information
    Member.find_by_email('meg@getbetter.com').try(:pha_profile).try(:update_attributes, {mayo_pilot: true})
  end

  def down
  end
end
