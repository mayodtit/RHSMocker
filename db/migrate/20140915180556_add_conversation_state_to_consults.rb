class AddConversationStateToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :conversation_state, :string
  end
end
