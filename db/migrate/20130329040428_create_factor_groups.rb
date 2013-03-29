class CreateFactorGroups < ActiveRecord::Migration
  def change
    create_table :factor_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
