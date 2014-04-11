class AddUserProgramToCard < ActiveRecord::Migration
  def change
    add_column :cards, :user_program_id, :integer
  end
end
