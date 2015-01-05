class AddAttributesToInsurancePolicies < ActiveRecord::Migration
  def change
    add_column :insurance_policies, :group_number, :string
    add_column :insurance_policies, :effective_date, :datetime
    add_column :insurance_policies, :termination_date, :datetime
    add_column :insurance_policies, :member_services_number, :string
    add_column :insurance_policies, :authorized, :boolean, default: false, null: false
    add_column :insurance_policies, :subscriber_name, :string
    add_column :insurance_policies, :plan, :string
    add_column :insurance_policies, :family_individual, :string
    add_column :insurance_policies, :employer_individual, :string
    add_column :insurance_policies, :employer_exchange, :string
    add_column :insurance_policies, :insurance_card_front_id, :integer
    add_column :insurance_policies, :insurance_card_back_id, :integer
    add_column :insurance_policies, :insurance_card_front_client_guid, :string
    add_column :insurance_policies, :insurance_card_back_client_guid, :string
  end
end