require 'spec_helper'
require 'stripe_mock'

describe 'Subscriptions' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  before do
    StripeMock.start
    @single_plan = Stripe::Plan.create(amount: 1999,
                                       interval: :month,
                                       name: 'Single Membership',
                                       currency: :usd,
                                       id: 'bp20',
                                       metadata: {
                                           display_name: 'Single Membership',
                                           display_price: '$19.99/month',
                                           active: 'true'
                                       })

    customer = Stripe::Customer.create(email: user.email,
                                       description: StripeExtension.customer_description(user.id),
                                       card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
    customer.subscriptions.create(:plan => 'bp20')
    user.update_attribute(:stripe_customer_id, customer.id)
  end

  after do
    StripeMock.stop
  end

  describe 'DELETE /api/v1/users/:user_id/subscriptions' do
    def do_request(params={})
      delete "/api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token)
    end

    it 'should stop the current subscription of the user' do
      do_request
      expect(response).to be_success
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      expect(customer.subscriptions.data.length).to eq(0)
    end
  end

end