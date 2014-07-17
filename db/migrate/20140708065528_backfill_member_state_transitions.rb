class BackfillMemberStateTransitions < ActiveRecord::Migration
  def up
    Member.reset_column_information
    now = Time.now
    Member.find_each do |m|
      if m.status?(:free) && m.read_attribute(:free_trial_ends_at).present?
        m.member_state_transitions.create!(actor: m,
                                           event: nil,
                                           from: nil,
                                           to: :trial,
                                           created_at: m.signed_up_at || m.created_at,
                                           updated_at: now,
                                           free_trial_ends_at: m.free_trial_ends_at)
        m.member_state_transitions.create!(actor: Member.robot,
                                           event: :downgrade,
                                           from: :trial,
                                           to: m.status,
                                           created_at: m.free_trial_ends_at,
                                           updated_at: now)
      else
        create_attributes = {
          actor: m,
          event: nil,
          from: nil,
          to: m.status,
          created_at: m.signed_up_at || m.created_at,
          updated_at: now
        }
        create_attributes[:free_trial_ends_at] = m.free_trial_ends_at if m.status?(:trial)
        m.member_state_transitions.create!(create_attributes)
      end
    end
  end

  def down
  end
end
