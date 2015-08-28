class CreateExpertises < ActiveRecord::Migration
  def change
    create_table :expertises do |t|
      t.string   "name"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
    add_index "expertises", ["name"], :name => "index_expertises_on_name"
  end
end
