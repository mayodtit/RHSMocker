class BackfillMemberSignedUpAt < ActiveRecord::Migration
  def up
    Member.reset_column_information
    Member.where('crypted_password IS NOT NULL').each do |m|
      m.update_attribute(:signed_up_at, m.created_at)
    end
  end

  def down
  end
end
