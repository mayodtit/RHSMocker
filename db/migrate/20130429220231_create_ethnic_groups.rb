class CreateEthnicGroups < ActiveRecord::Migration
  def change
    create_table :ethnic_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
