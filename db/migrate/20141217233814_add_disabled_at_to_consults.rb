class AddDisabledAtToConsults < ActiveRecord::Migration
  def change
    add_column :consults, :disabled_at, :datetime
  end
end
