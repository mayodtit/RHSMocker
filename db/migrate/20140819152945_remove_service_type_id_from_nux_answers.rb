class RemoveServiceTypeIdFromNuxAnswers < ActiveRecord::Migration
  def up
    remove_column :nux_answers, :service_type_id
  end

  def down
    add_column :nux_answers, :service_type_id, :integer
  end
end
