class ChangeTextColumnOnContents < ActiveRecord::Migration
  	change_table :contents do |t|
  		t.change :text, :string, :limit => 25000
	end
end
