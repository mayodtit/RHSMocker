class RemoveMedicalQuestionMessageTemplate < ActiveRecord::Migration
  def up
    MessageTemplate.find_by_name('New Premium Member Part 2: medical question').try(:destroy)
  end

  def down
  end
end
