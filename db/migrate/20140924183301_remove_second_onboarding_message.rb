class RemoveSecondOnboardingMessage < ActiveRecord::Migration
  def up
    MessageTemplate.find_by_name('New Premium Member Part 2: provider search').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: billing').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: medical condition').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: childcare').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: choosing insurance').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: pregnancy').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: eldercare').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: weightloss').try(:destroy)
    MessageTemplate.find_by_name('New Premium Member Part 2: something else').try(:destroy)
  end

  def down
  end
end
