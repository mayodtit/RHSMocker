class ChangeTextColumnOnContents < ActiveRecord::Migration
  	change_table :contents do |t|
  		t.change :text, :string
	end
end
