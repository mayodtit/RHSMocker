require 'spec_helper'

describe SubscriptionGroupUser do
  it_has_a 'valid factory'
  it_validates 'presence of', :subscription_group
  it_validates 'presence of', :user

  describe 'callbacks' do
    describe '#upgrade_user_to_premium' do
      context 'user is not premium, but has a pha' do
        let!(:pha) { create(:pha) }
        let!(:user) { create(:member, pha: pha) }

        it 'upgrades the user to premium keeping PHA the same' do
          expect(user).to_not be_is_premium
          expect(user.pha).to eq(pha)
          create(:subscription_group_user, user: user)
          expect(user).to be_is_premium
          expect(user.pha).to eq(pha)
        end
      end

      context 'user is not premium with no pha' do
        let!(:user) { create(:member) }

        it 'upgrades the user to premium assigning the PHA' do
          expect(user).to_not be_is_premium
          expect(user.pha).to be_nil
          subscription_group_user = create(:subscription_group_user, user: user)
          expect(user).to be_is_premium
          expect(user.pha).to eq(subscription_group_user.subscription_group.owner.pha)
        end
      end
    end

    describe '#downgrade_user_from_premium' do
      let!(:subscription_group_user) { create(:subscription_group_user) }

      it 'downgrades the user from premium on destroy' do
        user = subscription_group_user.user
        expect(user).to be_is_premium
        subscription_group_user.destroy
        expect(user.reload).to_not be_is_premium
      end
    end
  end
end
