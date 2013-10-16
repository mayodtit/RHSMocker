class AddPhoneCallSummaryIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :phone_call_summary_id, :integer
  end
end
