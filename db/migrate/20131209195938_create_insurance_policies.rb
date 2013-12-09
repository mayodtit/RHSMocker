class CreateInsurancePolicies < ActiveRecord::Migration
  def change
    create_table :insurance_policies do |t|
      t.references :user
      t.string :company_name
      t.string :plan_type
      t.string :policy_member_id
      t.timestamps
    end
  end
end
