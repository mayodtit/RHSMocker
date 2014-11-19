class AddSilenceLowWelcomeCallEmailToPhaProfiles < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :silence_low_welcome_call_email, :boolean, null: false, default: false
  end
end
