require 'spec_helper'
require 'stripe_mock'

describe Mails::NotifyTrialWillEndJob do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:credit_card_token) { stripe_helper.generate_card_token }
  let!(:pha) {create(:pha)}
  let!(:user) { create(:member, :trial, pha: pha) }

  before do
    Timecop.freeze(Date.today.to_time)
    StripeMock.start
    Stripe::Plan.create(amount: 1999,
                        interval: :month,
                        name: 'Better Premium, Single Membership',
                        currency: :usd,
                        id: 'bp20')
    subscription = CreateStripeSubscriptionService.new(user: user, plan_id: 'bp20', credit_card_token: credit_card_token).call
    user.update_attribute(:stripe_customer_id, subscription.customer)
  end

  after do
    Timecop.return
    StripeMock.stop
  end

  describe '::create' do
    let!(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id}) }

    it 'enqueues the job to run now' do
      expect{ described_class.create(event) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    let!(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id}) }

    it 'works' do
      described_class.new(event).perform
    end
  end
end
