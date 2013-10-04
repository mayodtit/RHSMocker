class CreatePhoneCallSummaries < ActiveRecord::Migration
  def change
    create_table :phone_call_summaries do |t|
      t.references :caller, :null => false
      t.references :callee, :null => false
      t.text :body, :null => false
      t.timestamps
    end
  end
end
