require 'spec_helper'
require 'stripe_mock'

describe StripeSubscriptionService do
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
  end

  after do
    StripeMock.stop
  end

  describe '#create' do
    context 'with a credit card token' do
      context 'without a strip account' do
        it 'creates a stripe customer with credit card' do
          Stripe::Customer.should_receive(:create).with(card: credit_card_token,
                                                        email: user.email,
                                                        description: StripeExtension.customer_description(user.id))
                                                  .and_call_original
          described_class.new(user, plan_id, credit_card_token).create
          expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards.count).to eq(1)
        end
      end

      context 'with a stripe account' do
        before do
          customer = Stripe::Customer.create(email: user.email,
                                             description: StripeExtension.customer_description(user.id))
          user.update_attribute(:stripe_customer_id, customer.id)
        end

        it 'adds the credit card to the customer' do
          expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards.count).to eq(0)
          described_class.new(user, plan_id, credit_card_token).create
          expect(Stripe::Customer.retrieve(user.stripe_customer_id).cards.count).to eq(1)
        end
      end

      it 'creates a new subscription for the customer' do
        described_class.new(user, plan_id, credit_card_token).create
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(1)
      end
    end

    context 'without a credit card token' do
      before do
        customer = Stripe::Customer.create(card: credit_card_token,
                                            email: user.email,
                                            description: StripeExtension.customer_description(user.id))
        user.update_attribute(:stripe_customer_id, customer.id)
      end

      it 'creates a new subscription for the customer' do
        described_class.new(user, plan_id).create
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.count).to eq(1)
      end
    end
  end
end
