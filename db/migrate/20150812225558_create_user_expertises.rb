class CreateUserExpertises < ActiveRecord::Migration
  def change
    create_table :user_expertises do |t|
      t.references :user
      t.references :expertise
      t.timestamps
    end
    add_index "user_expertises", ["expertise_id"], :name => "index_user_expertises_on_expertise_id"
  end
end
