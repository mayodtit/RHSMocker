class RemoveContentFromUserWeights < ActiveRecord::Migration
  def change
  	    remove_column :user_weights, :content_id
  end

end
