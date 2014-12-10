require 'spec_helper'
require 'stripe_mock'

describe 'subscriptions' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }
  before do
    StripeMock.start
    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                       card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
    plan =  Stripe::Plan.create(amount: 1999,
                                interval: :month,
                                name: 'Single Membership',
                                currency: :usd,
                                id: "bp20",
                                metadata: {
                                    display_name: 'Single Membership',
                                    display_price: '$19.99/month'})
    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  describe 'POST /api/v1/users/:user_id/subscriptions' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token,
                                                                   subscription: {plan_id: 'bp20'})
    end

    it 'send confirmation email to user when changes the subscription' do
      expect{ do_request }.to change(Delayed::Job, :count).by(1)
    end

    it_behaves_like 'success'
  end
end
