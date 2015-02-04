require 'spec_helper'
require 'stripe_mock'

describe '#send_charge_failed_notification' do
  let!(:user) {create(:member, :premium)}

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

  describe '#call' do

    def do_method
      event = StripeMock.mock_webhook_event('charge.failed', {customer: user.stripe_customer_id})
      SendChargeFailedNotification.new( event ).call
    end

    it 'should send user email and push notification if the user delinquent status is false' do
      expect{do_method}.to change(Delayed::Job, :count).by(2)
    end

    it 'should set the user delinquent status to true if the current is false' do
      expect{ do_method }.to change{ user.reload.delinquent }.from( false ).to ( true )
    end
  end
end
