class AddDisabledAtToInsurance < ActiveRecord::Migration
  def change
    add_column :insurance_policies, :disabled_at, :datetime
  end
end
