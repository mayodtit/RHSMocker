class CreateUserRequests < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      t.references :user
      t.references :subject
      t.string :name
      t.timestamps
    end
  end
end
