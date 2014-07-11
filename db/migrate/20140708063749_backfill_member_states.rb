class BackfillMemberStates < ActiveRecord::Migration
  def up
    Member.reset_column_information
    Member.find_each do |m|
      if m.read_attribute(:signed_up_at).nil?
        m.update_attribute(:status, :invited)
      elsif m.read_attribute(:is_premium) && m.read_attribute(:free_trial_ends_at).blank?
        m.update_attribute(:status, :premium)
      elsif m.read_attribute(:is_premium) && m.read_attribute(:free_trial_ends_at).present?
        m.update_attribute(:status, :trial)
      else
        m.update_attribute(:status, :free)
      end
    end
  end

  def down
  end
end
