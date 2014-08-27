class AddNuxAnswerIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :nux_answer_id, :integer
  end
end
