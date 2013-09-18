class CreateUserAgreements < ActiveRecord::Migration
  def change
    create_table :user_agreements do |t|
      t.references :user
      t.references :agreement
      t.string :user_agent
      t.string :ip_address
      t.timestamps
    end
  end
end
