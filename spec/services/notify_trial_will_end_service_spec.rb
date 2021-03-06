require 'spec_helper'
require 'stripe_mock'

describe NotifyTrialWillEndService do
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

  describe "#call" do
    def do_method
      id = Stripe::Customer.retrieve(user.stripe_customer_id).subscriptions.data[0].id
      event = StripeMock.mock_webhook_event('customer.subscription.trial_will_end', {customer: user.stripe_customer_id,
                                                                                     id: id})
      NotifyTrialWillEndService.new(event).call
    end

    context 'user is not downgraded' do
      it "should send a email to user" do
        Mails::NotifyTrialWillEndJob.should_receive(:create).and_call_original
        expect{do_method}.to change(Delayed::Job, :count).by(1)
      end
    end


    context 'user is downgraded' do
      before do
        user.downgrade!
      end

      it "should not send an email to user" do
        expect{do_method}.to change(Delayed::Job, :count).by(0)
      end
    end
  end
end
