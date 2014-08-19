class AddActiveToNuxAnswers < ActiveRecord::Migration
  def change
    add_column :nux_answers, :active, :boolean, default: true
  end
end
