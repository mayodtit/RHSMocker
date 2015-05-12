class CreateBmiDataLevels < ActiveRecord::Migration
  def change
    create_table :bmi_data_levels do |t|
      t.string :gender
      t.integer :age
      t.float :l
      t.float :m
      t.float :s

      t.timestamps
    end
  end
end
