class AddNotesToUserInformation < ActiveRecord::Migration
  def change
    add_column :user_informations, :notes, :text
  end
end
