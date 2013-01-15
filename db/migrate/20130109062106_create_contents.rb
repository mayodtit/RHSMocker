class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :headline
      t.string :text

      t.timestamps
    end
  end
end
