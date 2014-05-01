require 'spec_helper'

describe Subscription do
  let(:subscription) { build(:subscription) }

  it_has_a 'valid factory'
  it_validates 'presence of', :owner
  it_validates 'uniqueness of', :owner_id
  it 'validates owner is premium' do
    subscription.owner.update_attributes(is_premium: false)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:owner]).to include('must be premium')
  end
end
