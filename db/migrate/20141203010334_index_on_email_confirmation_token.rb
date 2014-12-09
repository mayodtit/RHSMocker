class IndexOnEmailConfirmationToken < ActiveRecord::Migration
  def up
     add_index "users", ["email_confirmation_token"], :name => "index_users_on_email_confirmation_token"
  end
end
