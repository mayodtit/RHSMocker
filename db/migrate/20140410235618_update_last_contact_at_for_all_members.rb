class UpdateLastContactAtForAllMembers < ActiveRecord::Migration
  def up
    Member.find_each do |m|
      m.initiated_consults.each do |c|
        consult_last_contact_at = nil
        consult_last_contact_at = c.created_at unless c.master
        last_message = c.messages.order('created_at ASC').last

        if last_message && last_message.created_at && (!consult_last_contact_at || consult_last_contact_at > last_message.created_at)
          consult_last_contact_at = last_message.created_at
        end

        if consult_last_contact_at && (!m.last_contact_at || m.last_contact_at > consult_last_contact_at)
          m.last_contact_at = consult_last_contact_at
        end
      end

      m.save!
    end
  end

  def down
    Member.update_all(last_contact_at: nil)
  end
end
