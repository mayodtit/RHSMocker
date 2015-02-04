require 'spec_helper'
require 'rspec_api_documentation/dsl'
require 'stripe_mock'

resource 'Plans' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let (:session) { user.sessions.create }
  let (:auth_token) { session.auth_token }
  let (:user_id) { user.id }
  let (:stripe_customer_id) { user.stripe_customer_id }

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

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/plans' do
    example_request '[GET] Retreive all available plans' do
      explanation 'Returns an array of addable plans'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:plans].count).to eq(3)
      expect(body[:text_header]).to_not be_blank
    end
  end

  get '/api/v1/users/:user_id/plans/available_options' do
    parameter :user_id, "target the current user"
    required_parameters :user_id

    before do
      @customer.subscriptions.create(:plan => @single_plan.id)
    end

    example_request '[GET]Retrieve available plans a user can update' do
      explanation 'Returns an array of available plans'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:plans].count).to eq(2)
      expect(body[:text_header]).to_not be_blank
    end
  end
end
