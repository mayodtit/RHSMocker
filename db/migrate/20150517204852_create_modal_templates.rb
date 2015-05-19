class CreateModalTemplates < ActiveRecord::Migration
  def change
    create_table :modal_templates do |t|
      t.string :title
      t.text :description
      t.string :accept
      t.string :reject
      t.timestamps
    end
  end
end
