class AddQueueToTask < ActiveRecord::Migration
  def change
    add_column :task, :queue, :string
  end
end
