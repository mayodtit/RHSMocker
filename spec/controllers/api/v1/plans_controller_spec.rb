require 'spec_helper'
require 'stripe_mock'

describe Api::V1::PlansController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:plan_id) { 'bp20' }

  before do
    StripeMock.start
    Stripe::Plan.create(amount: 1999,
                        interval: :month,
                        name: 'Single Membership',
                        currency: :usd,
                        id: plan_id,
                        metadata: {
                          display_name: 'Single Membership',
                          display_price: '$19.99/month'
                        })
    controller.stub(current_ability: ability)
  end

  after do
    StripeMock.stop
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      xit 'returns an array of plans' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:plans].to_json).to eq([plan].serializer.as_json.to_json)
      end
    end
  end
end
