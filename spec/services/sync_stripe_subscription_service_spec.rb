require 'spec_helper'
require 'stripe_mock'

describe 'SyncStripeSubscriptionService' do
  let(:user) { create(:member, :premium) }

  before do
    StripeMock.start
    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                       card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))

    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  context 'when subscription created event' do
    def do_method
      event = StripeMock.mock_webhook_event('customer.subscription.created', {customer: user.stripe_customer_id})
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscriptionService.new(event).call
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ user.subscriptions.count }.from(0).to(1)
      expect{ do_method }.to change{ user.subscriptions.last.is_current }.from( false ).to( true )
    end
  end

  context 'when subscription updated event' do
    let(:subscription) {create(:subscription, user_id: user.id, customer: user.stripe_customer_id)}

    def do_method
      event = StripeMock.mock_webhook_event('customer.subscription.updated', {customer: user.stripe_customer_id})
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscriptionService.new(event).call
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ user.subscriptions.count }.from(0).to(1)
      expect{ do_method }.to change{ user.subscriptions.last.is_current }.from( false ).to( true )
    end
  end

  context '#delete' do
    let(:subscription) {create(:subscription, user_id: user.id, customer: user.stripe_customer_id)}

    def do_method
      event = StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id})
      SyncStripeSubscriptionService.new(event).call
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ user.subscriptions.last.is_current }.from( true ).to( false )
    end
  end
end
