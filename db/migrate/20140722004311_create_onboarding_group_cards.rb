class CreateOnboardingGroupCards < ActiveRecord::Migration
  def change
    create_table :onboarding_group_cards do |t|
      t.references :onboarding_group
      t.references :resource, polymorphic: true
      t.integer :priority
      t.timestamps
    end
  end
end
