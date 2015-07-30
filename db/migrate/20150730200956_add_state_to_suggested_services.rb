class AddStateToSuggestedServices < ActiveRecord::Migration
  def change
    add_column :suggested_services, :state, :string
  end
end
