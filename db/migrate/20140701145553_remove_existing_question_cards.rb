class RemoveExistingQuestionCards < ActiveRecord::Migration
  def up
    Card.where(resource_type: 'Question', state: :unsaved).each do |c|
      next unless c.user.gender.blank?
      c.user.cards.create(resource: CustomCard.gender)
    end
    Card.where(resource_type: 'Question').delete_all
  end

  def down
  end
end
