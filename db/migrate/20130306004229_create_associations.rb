class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.references :user
      t.integer :associate_id
      t.string :relation_type
      t.string :relation

      t.timestamps
    end
    add_index :associations, :user_id
  end
end
