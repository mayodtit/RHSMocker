class CreateUserRequestTypes < ActiveRecord::Migration
  def change
    create_table :user_request_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
