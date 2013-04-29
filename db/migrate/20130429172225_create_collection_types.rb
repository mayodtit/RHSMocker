class CreateCollectionTypes < ActiveRecord::Migration
  def change
    create_table :collection_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
