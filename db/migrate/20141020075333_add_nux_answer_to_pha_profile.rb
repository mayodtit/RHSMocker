class AddNuxAnswerToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :nux_answer_id, :integer
  end
end
