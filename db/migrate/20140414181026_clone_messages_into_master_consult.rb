class CloneMessagesIntoMasterConsult < ActiveRecord::Migration
  def up
    add_column :messages, :cloned, :boolean

    Member.find_each do |member|
      next unless member.master_consult

      member.initiated_consults.each do |consult|
        next if consult.master

        consult.messages.each do |message|
          cloned_message = Message.new

          # Set consult id to master consult
          cloned_message.consult_id = member.master_consult.id
          cloned_message.cloned = true

          # Copy data
          cloned_message.text = message.text
          cloned_message.user_id = message.user_id
          cloned_message.created_at = message.created_at
          cloned_message.updated_at = message.updated_at
          cloned_message.content_id = message.content_id
          cloned_message.scheduled_phone_call_id = message.scheduled_phone_call_id
          cloned_message.phone_call_id = message.phone_call_id
          cloned_message.image = message.image
          cloned_message.phone_call_summary_id = message.phone_call_summary_id
          cloned_message.symptom_id = message.symptom_id
          cloned_message.condition_id = message.condition_id

          # Save this bad boy
          cloned_message.save! validate: false
        end
      end
    end
  end

  def down
    Message.where('cloned = ?', true).destroy_all

    remove_column :messages, :cloned
  end
end
