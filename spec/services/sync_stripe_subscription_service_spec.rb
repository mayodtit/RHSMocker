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

  context 'when received subscription created event' do
    let!(:subscription){create(:subscription, :bp20, current: true, user_id: user.id)}
    let(:event) {StripeMock.mock_webhook_event('customer.subscription.created', {customer: user.stripe_customer_id})}

    def do_method
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscriptionService.new(event).call
    end

    it 'should update the corresponding the subscription on local' do
      do_method
      expect(subscription.reload.stripe_subscription_id).to eq(event.data.object['id'])
    end
  end

  context 'when received subscription updated event' do
    let(:event) {StripeMock.mock_webhook_event('customer.subscription.updated', {customer: user.stripe_customer_id})}

    context 'upgrade the subscription' do
      let!(:previous_subscription) {create(:subscription, :bp20, user_id: user.id, customer: user.stripe_customer_id, current: false)}
      let!(:upgraded_subscription) {create(:subscription, :bp50, user_id: user.id, customer: user.stripe_customer_id, current: true)}

      def do_method
        event.data.object['tax_percent'] = nil
        event.data.object['discount'] = nil
        event.data.object['metadata'] = {}
        event.data.object.plan.amount = 5000
        SyncStripeSubscriptionService.new(event).call
      end

      it 'should update the corresponding subscription on local' do
        do_method
        expect(upgraded_subscription.reload.stripe_subscription_id).to eq(event.data.object['id'])
      end
    end

    context 'downgrade the subscription' do
      let!(:previous_subscription) {create(:subscription, :bp50, user_id: user.id, customer: user.stripe_customer_id, current: true)}
      let!(:downgraded_subscription) {create(:subscription, :bp20, user_id: user.id, customer: user.stripe_customer_id, current: false)}

      def do_method
        event = StripeMock.mock_webhook_event('customer.subscription.updated', {customer: user.stripe_customer_id})
        event.data.object['tax_percent'] = nil
        event.data.object['discount'] = nil
        event.data.object['metadata'] = {}
        event.data.object.plan.amount = 5
        SyncStripeSubscriptionService.new(event).call
      end

      it 'should update the corresponding subscription on local' do
        do_method
        expect(downgraded_subscription.reload.stripe_subscription_id).to eq(event.data.object['id'])
      end

      it 'should mark the new subscription as current at the end of the current subscription period and unmark the previous subscription' do
        expect{ do_method }.to change{ Delayed::Job.count }.by(2)
      end
    end
  end

  context 'when received subscription deleted event' do
    let!(:subscription) {create(:subscription, :bp20, user_id: user.id, customer: user.stripe_customer_id, current: true)}
    let(:event) {StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id})}

    def do_method
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscriptionService.new(event).call
    end

    it 'should update the corresponding subscription on local' do
      do_method
      expect(subscription.reload.stripe_subscription_id).to eq(event.data.object['id'])
      expect(subscription.reload.current).to eq(false)
    end
  end
end
