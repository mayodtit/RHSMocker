class SyncLastContactAtForMembers < ActiveRecord::Migration
  def up
    Member.find_each do |m|
      c = m.master_consult
      next unless c.present?

      last_message = c.messages.order('created_at ASC').last
      if last_message && m.last_contact_at < last_message.created_at
        last_message.update_initiator_last_contact_at
      end
    end
  end

  def down
  end
end
