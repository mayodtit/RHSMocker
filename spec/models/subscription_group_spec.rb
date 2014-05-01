require 'spec_helper'

describe SubscriptionGroup do
  let(:subscription_group) { build(:subscription_group) }

  it_has_a 'valid factory'
  it_validates 'presence of', :owner
  it 'validates owner is premium' do
    subscription_group.owner.update_attributes(is_premium: false)
    expect(subscription_group).to_not be_valid
    expect(subscription_group.errors[:owner]).to include('must be premium')
  end
end
