require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:nurse) { create(:nurse) }
  let!(:pha) { create(:pha) }
  let!(:user) { nurse }
  let(:session) { user.sessions.create }
  let(:pha_session) { pha.sessions.create }
  let(:auth_token) { session.auth_token }
  let!(:phone_call) { create(:phone_call, to_role: user.roles.first) }
  let!(:other_phone_call) { create(:phone_call, to_role: user.roles.first) }
  let!(:pha_phone_call) { create(:phone_call, to_role: pha.roles.first) }
  let!(:outbound_phone_call) { create(:phone_call, dialer: pha, outbound: true) }
  let!(:inbound_phone_call) { create(:phone_call, to_role: pha.roles.first, origin_phone_number: '4083913578') }
  let!(:inbound_nurse_phone_call) { create(:phone_call, to_role: nurse.roles.first, origin_phone_number: '4083913578') }
  let!(:pha_role) { Role.find_or_create_by_name! :pha }

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

  describe 'phone calls' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :state, 'Filter by the state of phone call (\'claimed\',\'unclaimed\', \'ended\')'

    required_parameters :auth_token

    let(:auth_token) { session.auth_token }
    let(:state) { 'unclaimed' }

    get '/api/v1/phone_calls/' do
      example_request '[GET] Get all phone calls' do
        explanation 'Get all phone calls (along with the caller\'s information), most recent first. Accessible only by HCPs'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:phone_calls].to_json).to eq([phone_call, other_phone_call, inbound_nurse_phone_call].serializer.as_json.to_json)
      end
    end
  end

  describe 'phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'

    required_parameters :auth_token, :id

    let(:auth_token) { session.auth_token }
    let(:id) { phone_call.id }

    get '/api/v1/phone_calls/:id' do
      example_request '[GET] Get a phone call' do
        explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
      end
    end
  end

  describe 'create phone call' do
    parameter :auth_token, "Member's auth_token"
    parameter :origin_phone_number, "Caller's phone number"
    parameter :destination_phone_number, "Callee's phone number"
    parameter :to_role, "Destination role, one of ['nurse', 'pha']"
    required_parameters :auth_token, :destination_phone_number

    let!(:user) { create(:member) }
    let!(:consult) { user.master_consult }
    let(:auth_token) { session.auth_token }
    let(:consult_id) { consult.id }
    let(:origin_phone_number) { '5551112222' }
    let(:destination_phone_number) { '5553334444' }
    let(:to_role) { 'pha' }
    let(:raw_post) { params.to_json }
    scope_parameters :phone_call, %i(origin_phone_number destination_phone_number to_role)

    post '/api/v1/consults/:consult_id/phone_calls' do
      example_request '[POST] Create a phone call' do
        explanation 'Create a new phone call'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        phone_call = PhoneCall.find(body[:phone_call][:id])
        expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
      end
    end
  end

  describe 'create outbound phone call' do
    parameter :auth_token, "HCP's auth_token"
    parameter :user_id, "HCP's phone number"
    parameter :destination_phone_number, "Destination's phone number"
    required_parameters :auth_token, :user_id, :destination_phone_number

    let!(:user) { create(:member) }
    let(:auth_token) { pha_session.auth_token }
    let(:user_id) { user.id }
    let(:destination_phone_number) { '5553334444' }
    let(:raw_post) { params.to_json }
    scope_parameters :phone_call, %i(user_id destination_phone_number)

    post '/api/v1/phone_calls/outbound' do
      example_request '[POST] Create a phone call' do
        explanation 'Create a new phone call'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        phone_call = PhoneCall.find(body[:phone_call][:id])
        phone_call.should be_outbound
        phone_call.user.should == user
        phone_call.creator.should == pha
        phone_call.destination_phone_number.should == '5553334444'
        expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
      end
    end
  end

  describe 'update phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'
    parameter :state_event, 'Event to perform on the phone call (\'claim\', \'end\', \'reclaim\', \'unclaim\')'

    required_parameters :auth_token, :id
    scope_parameters :phone_call, [:state_event]

    let(:auth_token) { session.auth_token }
    let(:id) { phone_call.id }
    let(:state_event) { 'claim' }

    let(:raw_post) { params.to_json }

    put '/api/v1/phone_calls/:id' do
      example_request '[PUT] Update a phone call' do
        explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:phone_call].to_json).to eq(phone_call.reload.serializer.as_json.to_json)
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

  describe 'twilio telling us a phone connected to nurseline' do
    parameter :From, 'Phone # of inbound caller'
    parameter :CallSid, 'Twilio call SID'

    required_parameters :From, :CallSid

    let(:From) { inbound_nurse_phone_call.origin_phone_number }
    let(:CallSid) { 'CA8f68d3676b5424bde1594cb34235076b' }
    let(:raw_post) { params.to_json }

    post '/api/v1/phone_calls/connect/nurse' do
      example_request '[POST] Determine how to route the nurseline phone call.' do
        explanation 'Twilio telling us that a nurseline phone connected and we need to route it properly.'
        status.should == 200
        inbound_nurse_phone_call.reload.should be_unclaimed
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
        phone_call_task = phone_call.phone_call_task
        phone_call_task.should be_abandoned
        task_change = TaskChange.last
        task_change.task.should == phone_call_task
        task_change.reason.should == 'after_hours'
        xml = Nokogiri::XML(response_body)
        xml.xpath('//Response/Play').text().should =~ /goodbye.aiff/
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

  describe 'hang up phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'

    required_parameters :auth_token, :id

    let(:auth_token) { pha_session.auth_token }
    let(:id) { pha_phone_call.id }
    let(:raw_post) { params.to_json }

    put '/api/v1/phone_calls/:id/hang_up' do
      example_request '[PUT] Hang up a phone call' do
        explanation 'Hang up a phone call'
        status.should == 200
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:phone_call].to_json).to eq(pha_phone_call.serializer.as_json.to_json)
      end
    end
  end

  describe 'transfer phone call' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'

    required_parameters :auth_token, :id

    let(:auth_token) { pha_session.auth_token }
    let(:id) { pha_phone_call.id }
    let(:raw_post) { params.to_json }

    put '/api/v1/phone_calls/:id/transfer' do
      example_request '[PUT] Transfers the phone call to nurseline' do
        explanation 'Transfer a phone call to nurseline'
        status.should == 200
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        pha_phone_call.reload
        expect(body[:phone_call].to_json).to eq(pha_phone_call.serializer.as_json.to_json)
        pha_phone_call.transferred_to_phone_call.should be_present
        pha_phone_call.transferred_to_phone_call.to_role.name.should == 'nurse'
      end
    end
  end

  describe 'merge phone call with member' do
    let!(:user) { pha }
    let!(:member) { create :member }
    let!(:phone_call) { create(:phone_call, state: :claimed, to_role: pha_role, user: nil, message: nil) }
    let!(:unresolved_phone_call) { create(:phone_call, state: :unresolved, to_role: pha_role, user: member) }

    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Phone call id'
    parameter :caller_id, 'Account to merge phone call into'

    required_parameters :auth_token, :id, :caller_id

    let(:auth_token) { session.auth_token }
    let(:id) { phone_call.id }
    let(:caller_id) { member.id }

    let(:raw_post) { params.to_json }

    put '/api/v1/phone_calls/:id/merge' do
      example_request '[PUT] Merge a phone call with a member' do
        explanation 'Merges a phone number with a member by merging an unresolved phone call or adding the member to the phone call'
        expect(status).to eq(200)
        unresolved_phone_call.reload
        unresolved_phone_call.should be_merged
        unresolved_phone_call.merged_into_phone_call_id.should == phone_call.id
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:phone_call].to_json).to eq(phone_call.reload.serializer.as_json.to_json)
      end
    end
  end
end
