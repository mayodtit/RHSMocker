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

    @family_plan = Stripe::Plan.create(amount:4999,
                                       interval: :month,
                                       name: 'Family Membership',
                                       currency: :usd,
                                       id: 'bp50',
                                       metadata: {
                                         display_name: 'Family Membership',
                                         display_price: '49.99/month',
                                         active: 'true'
                                       })

    @yearly_single_plan = Stripe::Plan.create(amount:14999,
                                       interval: :year,
                                       name: 'Yearly Single Membership',
                                       currency: :usd,
                                       id: 'bp150',
                                       metadata: {
                                           display_name: 'Yearly Single Membership',
                                           display_price: '149.99/month',
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

  describe 'Get /api/v1/users/:user_id/subscriptions' do
    def do_request(params={})
      get "/api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token)
    end

    it 'get the subscription of the user' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:subscriptions].to_json).to eq(user.subscriptions.to_json)
    end
  end

  describe 'Get /api/v1/users/:user_id/subscriptions/:id/available_options' do
    def do_request(params={})
      get "/api/v1/users/#{user.id}/subscriptions/:id/available_options", params.merge!(auth_token: session.auth_token)
    end

    it 'get the subscription of the user' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:plans].to_json).to eq([@family_plan, @yearly_single_plan].serializer.as_json.to_json)
    end
  end
end
