require 'spec_helper'
require 'stripe_mock'

describe DestroyStripeSubscriptionService do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:user) { create(:member, :premium) }
  let(:plan_id) { 'bp20' }
  let(:credit_card_token) { stripe_helper.generate_card_token }

  before do
    StripeMock.start
    Stripe::Plan.create(amount: 1999,
                        interval: :month,
                        name: 'Single Membership',
                        currency: :usd,
                        id: plan_id)
    CreateStripeSubscriptionService.new(user: user, plan_id: plan_id, credit_card_token: credit_card_token).call
  end

  after do
    StripeMock.stop
  end

  it 'destroy Stripe subscription service' do
    expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(1)
    described_class.new(user, :upgrade).call
    expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(0)
  end
end
