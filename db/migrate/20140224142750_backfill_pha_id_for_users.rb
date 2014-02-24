class BackfillPhaIdForUsers < ActiveRecord::Migration
  def up
    ScheduledPhoneCall.where('user_id IS NOT NULL')
                      .where('owner_id IS NOT NULL')
                      .includes(:user, :owner)
                      .each do |spc|
                        spc.user.update_attributes(pha: spc.owner)
                      end
  end

  def down
    Member.update_all(pha_id: nil)
  end
end
