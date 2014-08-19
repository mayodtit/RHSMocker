class AddTextToNuxAnswers < ActiveRecord::Migration
  def change
    add_column :nux_answers, :text, :text
  end
end
