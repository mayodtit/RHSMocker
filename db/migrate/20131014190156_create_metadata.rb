class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.string :key, :null => false
      t.string :value, :null => false
      t.timestamps
    end
  end
end
