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

    @customer = Stripe::Customer.create(email: user.email,
                                        description: StripeExtension.customer_description(user.id),
                                        card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))

    user.update_attribute(:stripe_customer_id, @customer.id)
  end

  after do
    StripeMock.stop
  end

  describe 'DELETE /api/v1/users/:user_id/subscriptions' do
    before do
      @customer.subscriptions.create(:plan => 'bp20')
    end

    def do_request(params={})
      delete "/api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token)
    end

    it 'should stop the current subscription of the user' do
      do_request
      expect(response).to be_success
      @customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      expect(@customer.subscriptions.data.first.cancel_at_period_end).to eq(true)
    end
  end

  describe 'Get /api/v1/users/:user_id/subscriptions' do
    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    def do_request(params = {})
      get "api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token)
    end

    it 'should get the subscription of the the user' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect( body[:subscriptions].first[:plan][:id] ).to eq( 'bp20' )
    end
  end

  describe 'POST /api/v1/users/:user_id/subscriptions' do
    def do_request(params = {})
      post "api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token,
                                                                  subscription: { plan_id: @single_plan.id })
    end

    it 'should create the a subscription for the user' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, symbolize_names: true)
      user.update_attributes({status_event: :upgrade, free_trial_ends_at: nil, subscription_ends_at: nil, actor_id: user.id})
      expect(body[:user].to_json).to eq(user.serializer.as_json.to_json )
    end
  end

  describe 'PUT /api/v1/users/:user_id/subscriptions' do
    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    def do_request(params = {})
      put "api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token,
                                                                 subscription: { plan_id: @family_plan.id })
    end

    it 'should update the subscription for the user ' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect( body[:new_subscription][:plan][:id] ).to eq( 'bp50' )
    end
  end
end
