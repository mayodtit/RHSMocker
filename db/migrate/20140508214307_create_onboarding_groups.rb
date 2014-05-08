class CreateOnboardingGroups < ActiveRecord::Migration
  def change
    create_table :onboarding_groups do |t|
      t.string :name
      t.boolean :premium, null: false, default: false
      t.integer :free_trial_days
      t.datetime :free_trial_ends_at
      t.timestamps
    end
  end
end
