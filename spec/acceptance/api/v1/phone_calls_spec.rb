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
  let!(:outbound_phone_call) { create(:phone_call, dialer: pha, outbound: true) }
  let!(:inbound_phone_call) { create(:phone_call, to_role: pha.roles.first, origin_phone_number: '4083913578') }
  let!(:resolved_inbound_phone_call) do
    phone_call = create(
      :phone_call,
      to_role: pha.roles.first,
      origin_phone_number: '4083913578',
      origin_twilio_sid: 'OTHERFAKETWILIOSID'
    )
    phone_call.resolve!
    phone_call
  end
  let(:claimed_phone_call) do
    phone_call = create(:phone_call, to_role: user.roles.first)
    phone_call.update_attributes(state_event: :claim, claimer: user)
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
        outbound_phone_call.reload
        outbound_phone_call.destination_twilio_sid.should == 'FAKETWILIOSID'
        outbound_phone_call.origin_status.should == PhoneCall::CONNECTED_STATUS
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
        outbound_phone_call.reload
        outbound_phone_call.destination_status.should == PhoneCall::CONNECTED_STATUS
      end
    end
  end

  describe 'twilio telling us a phone connected' do
    parameter :From, 'Phone # of inbound caller'
    parameter :CallSid, 'Twilio call SID'

    required_parameters :From, :CallSid

    let(:From) { inbound_phone_call.origin_phone_number }
    let(:CallSid) { 'CA8f68d3676b5424bde1594cb34235076b' }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/connect' do
      example_request '[POST] Determine how to route the phone call.' do
        explanation 'Twilio telling us that a phone connected and we need to route it properly.'
        status.should == 200
        inbound_phone_call.reload.should be_unclaimed
      end
    end
  end

  describe 'triage menu' do
    parameter :id, 'Phone call id'

    required_parameters :id

    let(:id) { phone_call.id }

    get '/api/v1/phone_calls/:id/triage/menu' do
      example_request '[GET] triage menu.' do
        explanation 'The triage menu for the inbound caller.'
        status.should == 200
      end
    end
  end

  describe 'triage select' do
    parameter :Digits, 'Phone call id'
    parameter :id, 'Phone call id'

    required_parameters :id, :Digits

    let(:id) { phone_call.id }
    let(:Digits) { '*' }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/triage/select' do
      example_request '[POST] Caller\'s selection from the triage menu' do
        explanation 'The caller selected an option from the triage menu, process it.'
        status.should == 200
        phone_call.reload.should be_missed
        xml = Nokogiri::XML(response_body)
        xml.xpath('//Response/Say').text().should == "Good bye."
      end
    end
  end

  describe 'twilio status update from a phone call\'s origin' do
    parameter :id, 'Phone call id'
    parameter :CallStatus, 'Status of the call'

    let(:id) { phone_call.id }
    let(:CallStatus) { 'completed' }

    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/status/origin' do
      example_request '[POST] Update the status of a phone call best on the origin\'s call status' do
        explanation 'Twilio telling us that the origin\'s call status has changed'
        status.should == 200
        phone_call.reload
        phone_call.should be_missed
        phone_call.origin_status.should == 'completed'
      end
    end
  end

  describe 'twilio status update from a phone call\'s destination' do
    parameter :id, 'Phone call id'
    parameter :CallStatus, 'Status of the call'

    let(:id) { phone_call.id }
    let(:CallStatus) { 'completed' }

    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/:id/status/destination' do
      example_request '[POST] Update the status of a phone call best on the destination\'s call status' do
        explanation 'Twilio telling us that the destination\'s call status has changed'
        status.should == 200
        phone_call.reload
        phone_call.should be_missed
        phone_call.destination_status.should == 'completed'
      end
    end
    end

  describe 'twilio status update' do
    parameter :CallSid, 'Twilio SID of the call'
    parameter :CallStatus, 'Status of the call'

    let(:CallSid) { resolved_inbound_phone_call.origin_twilio_sid }
    let(:CallStatus) { 'completed' }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/status' do
      example_request '[POST] Update the status of a phone call' do
        explanation 'Twilio telling us that a phone call has changed in status'
        status.should == 200
        resolved_inbound_phone_call.reload
        resolved_inbound_phone_call.should be_missed
        resolved_inbound_phone_call.origin_status.should == 'completed'
      end
    end
  end
end
