class AddIndexOnPhoneCallId < ActiveRecord::Migration
  def up
    add_index "messages", ["phone_call_id"], :name => "index_messages_on_phone_call_id"
  end
end
