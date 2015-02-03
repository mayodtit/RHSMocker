require 'spec_helper'
require 'stripe_mock'
require 'rspec_api_documentation/dsl'

resource 'Subscriptions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let (:session) { user.sessions.create }
  let (:auth_token) { session.auth_token }
  let (:user_id) { user.id }
  let (:stripe_customer_id) { user.stripe_customer_id }

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

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


  get '/api/v1/users/:user_id/subscriptions' do
    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    example_request '[GET] Retrieve user subscription' do
      explanation 'Returns the user subscription'
      status.should == 200
      body = JSON.parse(response_body, symbolize_names: true)
      expect( body[:subscriptions][:plan].to_json ).to eq( @single_plan.as_json.to_json )
    end
  end


  post '/api/v1/users/:user_id/subscriptions' do
    parameter :subscription, 'Contains subscription information'
    parameter :plan_id, 'Plan ID for subscription'

    required_parameters :subscription, :plan_id
    scope_parameters :subscription, [:plan_id]

    let(:plan_id) { @single_plan.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create a new subscription for the user' do
      explanation 'Returns the updated user object'
      status.should == 200
      body = JSON.parse(response_body, symbolize_names: true)
      expect( body[:subscription][:plan][:id] ).to eq( 'bp20' )
    end
  end

  delete '/api/v1/users/:user_id/subscriptions' do
    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    let(:raw_post) { params.to_json }

    example_request '[DELETE] Delete the subscription of the user' do
      explanation 'Returns success status if deleted the subscription'
      status.should == 200
    end
  end

  put '/api/v1/users/:user_id/subscriptions' do
    parameter :subscription, 'Contains subscription information'
    parameter :plan_id, 'Plan ID for subscription'

    required_parameters :subscription, :plan_id
    scope_parameters :subscription, [:plan_id]

    let(:plan_id) { @family_plan.id }
    let(:raw_post) { params.to_json }

    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    example_request '[PUT] Update a subscription for the user' do
      explanation 'Returns the updated new subscription object'
      status.should == 200
      body = JSON.parse(response_body, symbolize_names: true)
      expect( body[:subscription][:plan].to_json ).to eq( @family_plan.as_json.to_json )
    end
  end
end
