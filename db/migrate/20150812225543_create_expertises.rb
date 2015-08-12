class CreateExpertises < ActiveRecord::Migration
  def change
    create_table :expertises do |t|
      t.string   "name"
      t.integer  "resource_id"
      t.string   "resource_type"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
    add_index "expertises", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
    add_index "expertises", ["name"], :name => "index_roles_on_name"
  end
end
