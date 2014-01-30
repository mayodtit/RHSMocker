class AddNotesToInsurancePolicy < ActiveRecord::Migration
  def change
    add_column :insurance_policies, :notes, :text
  end
end
