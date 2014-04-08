require 'spec_helper'

describe ScheduledJobs do
  describe '#unset_premium_for_expired_subscriptions' do
    it 'should unset premium flag for users with expired subscriptions' do
      u1 = create(:user, is_premium: true, subscription_end_date: 1.day.ago)
      u2 = create(:user, is_premium: true, subscription_end_date: 1.hour.from_now)
      u3 = create(:user, is_premium: true, subscription_end_date: nil)

      ScheduledJobs.unset_premium_for_expired_subscriptions
      u1.reload.is_premium.should be_false
      u1.reload.subscription_end_date.should be_nil
      u2.reload.is_premium.should be_true
      u2.reload.subscription_end_date.should_not be_nil
      u3.reload.is_premium.should be_true
      u3.reload.subscription_end_date.should be_nil
    end
  end
end
