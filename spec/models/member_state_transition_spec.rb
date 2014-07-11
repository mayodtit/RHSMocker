require 'spec_helper'

describe MemberStateTransition do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :to_trial
  it_validates 'presence of', :member
  it_validates 'presence of', :actor

  context 'to trial' do
    let(:member_state_transition) { build_stubbed(:member_state_transition, :to_trial) }

    it 'validates free_trial_ends_at' do
      expect(member_state_transition).to be_valid
      member_state_transition.free_trial_ends_at = nil
      expect(member_state_transition).to_not be_valid
      expect(member_state_transition.errors[:free_trial_ends_at]).to include("can't be blank")
    end
  end
end
