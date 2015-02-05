require 'spec_helper'
require 'stripe_mock'

describe 'DowngradeMemberToFree' do
  let(:user){create(:member, :premium)}

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
      event = StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: user.stripe_customer_id})
      DowngradeMemberToFree.new(event).call
    end

    it 'should set user status to free' do
      expect{ do_method }.to change{ user.reload.status }.from('premium').to('free')
    end
  end
end