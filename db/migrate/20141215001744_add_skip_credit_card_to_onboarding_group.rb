class AddSkipCreditCardToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :skip_credit_card, :boolean, null: false, default: false
  end
end
