require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:nurse) }
  let!(:pha) { create(:pha) }
  let(:auth_token) { user.auth_token }
  let!(:phone_call) { create(:phone_call, to_role: user.roles.first) }
  let!(:other_phone_call) { create(:phone_call, to_role: user.roles.first) }
  let!(:outbound_phone_call) { create(:phone_call, dialer: pha, to_role: nil) }
  let(:claimed_phone_call) do
    phone_call = create(:phone_call, to_role: user.roles.first)
    phone_call.claim! user
    phone_call
  end

  before(:each) do
    user.login
  end

  describe 'phone calls' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :state, 'Filter by the state of phone call (\'claimed\',\'unclaimed\', \'ended\')'

    required_parameters :auth_token

    let(:auth_token) { user.auth_token }
    let(:state) { 'unclaimed' }

    get '/api/v1/phone_calls/' do
      example_request '[GET] Get all phone calls' do
        explanation 'Get all phone calls (along with the caller\'s information), most recent first. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:phone_calls].to_json.should == [phone_call, other_phone_call].as_json(
          include: {
            user: {
              only: [:first_name, :last_name, :email],
              methods: [:full_name]
            }
          }
        ).to_json
      end
    end
  end

  describe 'phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'

    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id) { phone_call.id }

    get '/api/v1/phone_calls/:id' do
      example_request '[GET] Get a phone call' do
        explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:phone_call].to_json.should == phone_call.as_json(include: [:user, consult: {include: [:subject, :initiator]}]).to_json
      end
    end
  end

  describe 'update phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'
    parameter :state_event, 'Event to perform on the phone call (\'claim\', \'end\', \'reclaim\', \'unclaim\')'

    required_parameters :auth_token, :id
    scope_parameters :phone_call, [:state_event]

    let(:auth_token) { user.auth_token }
    let(:id) { phone_call.id }
    let(:state_event) { 'claim' }

    let(:raw_post) { params.to_json }

    put '/api/v1/phone_calls/:id' do
      example_request '[PUT] Update a phone call' do
        explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:phone_call].to_json.should == phone_call.reload.as_json(include: [:user, consult: {include: [:subject, :initiator]}]).to_json
      end
    end
  end

  describe 'twilio telling us phone call\'s origin connected' do
    parameter :id, 'Phone call id'

    let(:id) { outbound_phone_call.id }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/connect/origin' do
      example_request '[POST] Indicates phone call\'s origin connected' do
        explanation 'Dials the destination'
        status.should == 200
      end
    end
  end

  describe 'twilio telling us phone call\'s destination connected' do
    parameter :id, 'Phone call id'

    let(:id) { outbound_phone_call.id }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/connect/destination' do
      example_request '[POST] Indicates phone call\'s destination connected' do
        explanation 'and that\s it.'
        status.should == 200
      end
    end
  end

  describe 'twilio telling us a phone connected' do
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/status' do
      example_request '[POST] Determine how to route the phone call.' do
        explanation 'Twilio telling us that a phone connected and we need to route it properly.'
        status.should == 200
      end
    end
  end

  describe 'twilio status update from a phone call\'s origin' do
    parameter :id, 'Phone call id'

    let(:id) { phone_call.id }

    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/status/origin' do
      example_request '[POST] Update the status of a phone call best on the origin\'s call status' do
        explanation 'Twilio telling us that the origin\'s call status has changed'
        status.should == 200
      end
    end
  end

  describe 'twilio status update from a phone call\'s destination' do
    parameter :id, 'Phone call id'

    let(:id) { phone_call.id }

    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/status/destination' do
      example_request '[POST] Update the status of a phone call best on the destination\'s call status' do
        explanation 'Twilio telling us that the destination\'s call status has changed'
        status.should == 200
      end
    end
    end

  describe 'twilio status update' do
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/status' do
      example_request '[POST] Update the status of a phone call' do
        explanation 'Twilio telling us that a phone call has changed in status'
        status.should == 200
      end
    end
  end
end
