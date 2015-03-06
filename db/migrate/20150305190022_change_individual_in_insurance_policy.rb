class ChangeIndividualInInsurancePolicy < ActiveRecord::Migration
  def change
    InsurancePolicy.where(employer_individual: "individual").update_all(employer_exchange: "exchange")
    remove_column :insurance_policies, :employer_individual
  end
end
