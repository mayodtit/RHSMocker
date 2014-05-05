require 'spec_helper'

describe ScheduledJobs do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe '#unset_premium_for_expired_subscriptions' do
    it 'should unset premium flag for users with expired subscriptions' do
      u1 = create(:user, is_premium: true, free_trial_ends_at: 1.day.ago)
      u2 = create(:user, is_premium: true, free_trial_ends_at: 1.hour.from_now)
      u3 = create(:user, is_premium: true, free_trial_ends_at: nil)

      ScheduledJobs.unset_premium_for_expired_subscriptions
      u1.reload.is_premium.should be_false
      u1.reload.free_trial_ends_at.should be_nil
      u2.reload.is_premium.should be_true
      u2.reload.free_trial_ends_at.should_not be_nil
      u3.reload.is_premium.should be_true
      u3.reload.free_trial_ends_at.should be_nil
    end
  end
end
