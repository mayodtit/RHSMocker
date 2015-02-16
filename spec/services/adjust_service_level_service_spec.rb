require 'spec_helper'
require 'stripe_mock'

describe AdjustServiceLevelService do
  let(:user) { create(:member, :trial) }

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

  describe "#call" do
    let(:event) {StripeMock.mock_webhook_event('invoice.payment_succeeded', {customer: user.stripe_customer_id})}

    def do_method
      AdjustServiceLevelService.new(event).call
    end

    it 'should update user status to premium' do
      expect{ do_method }.to change{ user.reload.status }.from('trial').to('premium')
    end
  end
end