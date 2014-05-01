require 'spec_helper'

describe SubscriptionUser do
  it_has_a 'valid factory'
  it_validates 'presence of', :subscription
  it_validates 'presence of', :user

  describe 'callbacks' do
    describe '#upgrade_user_to_premium' do
      context 'user is not premium, but has a pha' do
        let!(:pha) { create(:pha) }
        let!(:user) { create(:member, pha: pha) }

        it 'upgrades the user to premium keeping PHA the same' do
          expect(user).to_not be_is_premium
          expect(user.pha).to eq(pha)
          create(:subscription_user, user: user)
          expect(user).to be_is_premium
          expect(user.pha).to eq(pha)
        end
      end

      context 'user is not premium with no pha' do
        let!(:user) { create(:member) }

        it 'upgrades the user to premium assigning the PHA' do
          expect(user).to_not be_is_premium
          expect(user.pha).to be_nil
          subscription_user = create(:subscription_user, user: user)
          expect(user).to be_is_premium
          expect(user.pha).to eq(subscription_user.subscription.owner.pha)
        end
      end
    end

    describe '#downgrade_user_from_premium' do
      let!(:subscription_user) { create(:subscription_user) }

      it 'downgrades the user from premium on destroy' do
        user = subscription_user.user
        expect(user).to be_is_premium
        subscription_user.destroy
        expect(user.reload).to_not be_is_premium
      end
    end
  end
end
