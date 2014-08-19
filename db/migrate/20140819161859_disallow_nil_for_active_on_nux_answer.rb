class DisallowNilForActiveOnNuxAnswer < ActiveRecord::Migration
  def up
    change_column :nux_answers, :active, :boolean, default: true, null: false
  end

  def down
    change_column :nux_answers, :active, :boolean, default: true, null: true
  end
end
