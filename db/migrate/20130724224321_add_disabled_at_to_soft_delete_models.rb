class AddDisabledAtToSoftDeleteModels < ActiveRecord::Migration
  def change
    add_column :allergies, :disabled_at, :datetime
    add_column :association_types, :disabled_at, :datetime
    add_column :diets, :disabled_at, :datetime
    add_column :diseases, :disabled_at, :datetime
    add_column :ethnic_groups, :disabled_at, :datetime
    add_column :treatments, :disabled_at, :datetime
  end
end
