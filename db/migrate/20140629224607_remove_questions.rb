class RemoveQuestions < ActiveRecord::Migration
  def up
    drop_table :questions
  end

  def down
    create_table "questions", :force => true do |t|
      t.string   "title"
      t.string   "view"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
