class AddTreatmentSubtypes < ActiveRecord::Migration
  def up
    add_column :treatments, :type, :string
    Treatment.update_all(:type => 'Treatment::Medicine')
  end

  def down
    remove_column :treatments, :type
  end
end
