class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :email_domain
    end
  end
end
