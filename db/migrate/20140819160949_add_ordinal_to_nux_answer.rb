class AddOrdinalToNuxAnswer < ActiveRecord::Migration
  def change
    add_column :nux_answers, :ordinal, :integer
  end
end
