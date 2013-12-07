class CreateCustomCards < ActiveRecord::Migration
  def change
    create_table :custom_cards do |t|
      t.references :content
      t.string :title
      t.text :body
      t.timestamps
    end
  end
end
