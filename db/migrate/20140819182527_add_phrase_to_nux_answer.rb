class AddPhraseToNuxAnswer < ActiveRecord::Migration
  def change
    add_column :nux_answers, :phrase, :text
  end
end
