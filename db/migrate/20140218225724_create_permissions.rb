class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :subject
      t.string :name
      t.string :level
      t.timestamps
    end
  end
end
