class BackfillRecipientFromScheduledCommunications < ActiveRecord::Migration
  def up
    ScheduledCommunication.find_each do |sc|
      if consult = Consult.find_by_id(sc.read_attribute(:consult_id))
        sc.update_attributes!(recipient: consult.initiator)
      end
    end
  end

  def down
  end
end
