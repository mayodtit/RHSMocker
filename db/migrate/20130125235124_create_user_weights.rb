class CreateUserWeights < ActiveRecord::Migration
  def change
    create_table :user_weights do |t|
      t.integer :user_id
      t.integer :content_id
      t.decimal :weight, :precision => 6, :scale => 2, :default => 0
      t.decimal :bmi, :precision => 5, :scale => 2, :default => 0
      t.timestamps
    end
  end
end
