class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :token
      t.string :email
      t.string :crypted_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :advertiser_id
      t.string :time_zone
      t.timestamps
    end
  end
end
