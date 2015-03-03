class RenameSkipInitialMessage < ActiveRecord::Migration
  def change
    rename_column :onboarding_groups, :skip_initial_message, :skip_automated_communications
  end
end
