require 'spec_helper'
require 'stripe_mock'

describe 'SyncStripeSubscription' do
  let!(:user) { create(:member, :premium) }
  
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

  describe '#create' do
    def do_method
      event = StripeMock.mock_webhook_event('customer.subscription.created', {customer: user.stripe_customer_id})
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscription.new(event).create
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ Subscription.all.count }.from(0).to(1)
    end
  end

  describe '#update' do
    let!(:subscription) {create(:subscription, user_id: user.id, customer: user.stripe_customer_id)}
    let!(:event) {StripeMock.mock_webhook_event('customer.subscription.updated', {customer: user.stripe_customer_id})}

    def do_method
      event.data.object['tax_percent'] = nil
      event.data.object['discount'] = nil
      event.data.object['metadata'] = {}
      SyncStripeSubscription.new(event).update
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ subscription.reload.plan_id }.from('bp').to( event.data.object.plan.id)
    end
  end

  describe '#delete' do
    let!(:subscription) {create(:subscription, user_id: user.id, customer: user.stripe_customer_id)}

    def do_method
      event = StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id})
      SyncStripeSubscription.new(event).delete
    end

    it 'should create the subscription on local' do
      expect{ do_method }.to change{ Subscription.all.count }.from(1).to(0)
    end
  end
end