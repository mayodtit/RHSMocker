require 'spec_helper'
require 'stripe_mock'

describe 'Plans' do
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
  end

  after do
    StripeMock.stop
  end

  describe 'GET /api/v1/plans' do
    def do_request
      get '/api/v1/plans', auth_token: session.auth_token
    end

    it_behaves_like 'success'

    it 'returns all the plans' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:plans].count).to eq(3)
    end

    it 'return plans with text header' do
      do_request
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:text_header]).to_not be_blank
    end
  end

  describe ' GET /api/v1/users/:user_id/plans/available_options' do
    before do
      @customer = Stripe::Customer.create(email: user.email,
                                          description: StripeExtension.customer_description(user.id),
                                          card: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))

      user.update_attribute(:stripe_customer_id, @customer.id)
    end

    def do_request(params={})
      get "/api/v1/users/#{user.id}/plans/available_options", params.merge!(auth_token: session.auth_token)
    end

    context 'user has a plan subscribed' do
      before do
        @customer.subscriptions.create(:plan => 'bp20')
      end

      it 'should get user the available plans' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:available_plans].to_json).to eq([@family_plan, @yearly_single_plan].serializer.as_json.to_json)
      end
    end

    context 'user do not have a plan subscribed' do
      it 'should return all the plans' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:available_plans].to_json).to eq([@single_plan, @family_plan, @yearly_single_plan].serializer.as_json.to_json)
      end
    end
  end
end
