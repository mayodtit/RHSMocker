require 'spec_helper'

describe Mails::ConfirmSubscriptionChangeJob do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:credit_card_token) { stripe_helper.generate_card_token }
  let!(:user) { create(:member, :free) }
  let!(:plan) { double( 'plan', :name => "stripe_plan")}
  let!(:subscription) { double( 'subscription', :customer => "stripe_customer", :plan => plan)}

  before do
    Timecop.freeze(Date.today.to_time)
    user.update_attribute(:stripe_customer_id, subscription.customer)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(user.id, subscription) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(user.id, subscription).perform
    end
  end
end
