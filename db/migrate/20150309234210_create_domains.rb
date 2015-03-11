class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :email_domain
      t.timestamps
    end
  end
end
