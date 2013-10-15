require 'spec_helper'

describe Subscription do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :plan
  it_validates 'scoped uniqueness of', :plan_id, :user_id

  describe 'callbacks' do
    describe '#add_credits_to_user!' do
      let(:subscription) { build(:subscription) }
      let(:user) { subscription.user }

      it 'adds credits on create' do
        expect{ subscription.save! }.to change{ user.credits.count }
      end
    end
  end
end
