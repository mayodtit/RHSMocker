class CreateSideEffects < ActiveRecord::Migration
  def change
    create_table :side_effects do |t|
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end
  end
end
