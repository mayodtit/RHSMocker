require 'spec_helper'
require 'stripe_mock'

describe 'Plans' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  before do
    StripeMock.start
    @plan = Stripe::Plan.create(amount: 1999,
                                interval: :month,
                                name: 'Single Membership',
                                currency: :usd,
                                id: 'bp20',
                                metadata: {
                                  display_name: 'Single Membership',
                                  display_price: '$19.99/month',
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
      expect(body[:plans].to_json).to eq([StripeExtension.plan_serializer(@plan, user)].to_json)
    end

    it 'return plans with text header' do
      do_request
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:text_header]).to_not be_blank
    end
  end
end
