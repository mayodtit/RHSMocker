class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.string :ip_address
      t.string :user_agent
      t.references :agreement_page
      t.references :user

      t.timestamps
    end
    add_index :agreements, :agreement_page_id
    add_index :agreements, :user_id
  end
end
