class CreateNewAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.text :text
      t.string :type
      t.boolean :active, :null => false, :default => false
      t.timestamps
    end
  end
end
