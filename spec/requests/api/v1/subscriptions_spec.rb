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
  end

  after do
    StripeMock.stop
  end

  describe 'POST /api/v1/users/:user_id/subscriptions' do
    def do_request(params={})
      create "api/v1/users/#{user.id}/subscriptions", params.merge!(auth_token: session.auth_token,
                                                                    plan_id: @single_plan.id)
    end

    it 'should create the a subscription for the user' do
      do_request
    end
  end
end