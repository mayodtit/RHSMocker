class AddUpdateDateToContent < ActiveRecord::Migration
  def change
		add_column :contents, :updateDate, :timestamp 
  end
end
