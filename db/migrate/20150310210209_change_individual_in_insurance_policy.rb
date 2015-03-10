class ChangeIndividualInInsurancePolicy < ActiveRecord::Migration
  def up
    InsurancePolicy.where(employer_individual: "individual").update_all(employer_exchange: "exchange")
    remove_column :insurance_policies, :employer_individual
  end

  def down
    add_column :insurance_policies, :employer_individual, :string
  end
end
