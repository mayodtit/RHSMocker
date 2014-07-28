class CreateOnboardingGroupPrograms < ActiveRecord::Migration
  def change
    create_table :onboarding_group_programs do |t|
      t.references :onboarding_group
      t.references :program
      t.timestamps
    end
  end
end
