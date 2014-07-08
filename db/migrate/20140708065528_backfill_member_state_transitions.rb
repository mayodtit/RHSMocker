class BackfillMemberStateTransitions < ActiveRecord::Migration
  def up
    Member.reset_column_information
    now = Time.now
    Member.find_each do |m|
      if m.status?(:free) && m.read_attribute(:free_trial_ends_at).present?
        m.member_state_transitions.create!(event: nil,
                                           from: nil,
                                           to: :trial,
                                           created_at: m.signed_up_at || m.created_at,
                                           updated_at: now)
        m.member_state_transitions.create!(event: :downgrade,
                                           from: :trial,
                                           to: m.status,
                                           created_at: m.free_trial_ends_at,
                                           updated_at: now)
      else
        m.member_state_transitions.create!(event: nil,
                                           from: nil,
                                           to: m.status,
                                           created_at: m.signed_up_at || m.created_at,
                                           updated_at: now)
      end
    end
  end

  def down
  end
end
