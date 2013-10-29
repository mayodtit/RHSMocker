class AddDefaultsToContent < ActiveRecord::Migration
  def up
    change_column :contents, :title, :string, :null => false, :default => ''
    change_column :contents, :body, :text, :null => false, :default => ''
    change_column :contents, :content_type, :string, :null => false, :default => ''
    change_column :contents, :mayo_doc_id, :string, :null => false, :default => ''
    change_column :contents, :show_call_option, :boolean, :null => false, :default => true
    change_column :contents, :show_checker_option, :boolean, :null => false, :default => true
  end

  def down
    change_column :contents, :title, :string, :null => true, :default => nil
    change_column :contents, :body, :text, :null => true, :default => nil
    change_column :contents, :content_type, :string, :null => true, :default => nil
    change_column :contents, :mayo_doc_id, :string, :null => true, :default => nil
    change_column :contents, :show_call_option, :boolean, :null => true, :default => nil
    change_column :contents, :show_checker_option, :boolean, :null => true, :default => nil
  end
end
