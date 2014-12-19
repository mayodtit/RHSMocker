require 'spec_helper'
require 'stripe_mock'

describe 'UpdateStripeSubscriptionService' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:user) { create(:member, :premium) }
  let(:credit_card_token) { stripe_helper.generate_card_token }

  before do
    StripeMock.start
    Stripe::Plan.create(amount: 1999,
                        interval: :month,
                        name: 'Single Membership',
                        currency: :usd,
                        id: 'bp50')
    subscription = CreateStripeSubscriptionService.new(user: user, plan_id: 'bp50', credit_card_token: credit_card_token).call
    user.update_attribute(:stripe_customer_id, subscription.customer)
  end

  after do
    StripeMock.stop
  end

  describe '#call' do
    context 'update user immediately' do
      let(:plan_id) { 'bpYRSingle192' }

      def do_method
        described_class.new(user, plan_id).call
      end

      it 'should update the customer‘s subscription' do
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.data[0].id).to eq('bp50')
        do_method
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.data[0].id).to eq('bpYRSingle192')
      end

      it 'prorate and create the invoice immediately' do
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).invoices.data[-1].lines.data[0].plan.id).to eq('bp50')
        do_method
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).invoices.data[-1].lines.data[0].proration).to eq(true)
        expect(Stripe::Customer.retrieve(user.stripe_customer_id).invoices.data[-1].lines.data[0].plan.id).to eq('bpYRSingle192')
      end
    end

    # context 'downgrade the user at end of current period' do
    #   let(:plan_id) { 'bp20' }
    #
    #   def do_method
    #     described_class.new(user, plan_id).call
    #   end
    #
    #   it 'should update the customer‘s subscription at end of current period' do
    #     expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.data[0].id).to eq('bp50')
    #     do_method
    #     expect(Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.data[0].id).to eq('bp20')
    #   end
    # end
  end
end