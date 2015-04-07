require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  let(:nurse_role) { create(:role, name: 'nurse') }

  context 'as a Nurse or PHA' do
    let!(:user) { create(:nurse) }
    let(:session) { user.sessions.create }
    let(:auth_token) { session.auth_token }

    context 'existing record' do
      let!(:phone_call) { create(:phone_call, to_role: Role.nurse) }

      get '/api/v1/phone_calls' do
        parameter :state, 'Filter by the state of phone call (\'claimed\',\'unclaimed\', \'ended\')'

        let(:state) { 'unclaimed' }

        example_request '[GET] Get all phone calls' do
          explanation "Get all phone calls (along with the caller's information), most recent first. Accessible only by HCPs"
          expect(status).to eq(200)
          body = JSON.parse(response_body, symbolize_names: true)
          expect(body[:phone_calls].to_json).to eq([phone_call].serializer.as_json.to_json)
        end
      end

      get '/api/v1/phone_calls/:id' do
        parameter :id, 'Phone call id'
        required_parameters :id

        let(:id) { phone_call.id }

        example_request '[GET] Get a phone call' do
          explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
          expect(status).to eq(200)
          body = JSON.parse(response_body, symbolize_names: true)
          expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
        end
      end

      put '/api/v1/phone_calls/:id' do
        parameter :id, 'Phone call id'
        parameter :state_event, 'Event to perform on the phone call (\'claim\', \'end\', \'reclaim\', \'unclaim\')'
        scope_parameters :phone_call, [:state_event]
        required_parameters :id

        let(:id) { phone_call.id }
        let(:state_event) { 'claim' }
        let(:raw_post) { params.to_json }

        example_request '[PUT] Update a phone call' do
          explanation 'Get a phone call (along with the caller\'s information). Accessible only by HCPs'
          expect(status).to eq(200)
          body = JSON.parse(response_body, symbolize_names: true)
          expect(body[:phone_call].to_json).to eq(phone_call.reload.serializer.as_json.to_json)
        end
      end
    end

    post '/api/v1/consults/:consult_id/phone_calls' do
      parameter :origin_phone_number, "Caller's phone number"
      parameter :destination_phone_number, "Callee's phone number"
      parameter :to_role, "Destination role, one of ['nurse', 'pha']"
      scope_parameters :phone_call, %i(origin_phone_number destination_phone_number to_role)
      required_parameters :destination_phone_number

      let!(:user) { create(:member) }
      let!(:consult) { user.master_consult }
      let(:consult_id) { consult.id }
      let(:origin_phone_number) { '5551112222' }
      let(:destination_phone_number) { '5553334444' }
      let(:to_role) { 'pha' }
      let(:raw_post) { params.to_json }

      example_request '[POST] Create a phone call' do
        explanation 'Create a new phone call'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        phone_call = PhoneCall.find(body[:phone_call][:id])
        expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
      end
    end
  end

  context 'as a PHA' do
    let!(:pha) { create(:pha) }
    let(:session) { pha.sessions.create }
    let(:auth_token) { session.auth_token }

    post '/api/v1/phone_calls/outbound' do
      parameter :user_id, "HCP's phone number"
      parameter :destination_phone_number, "Destination's phone number"
      scope_parameters :phone_call, %i(user_id destination_phone_number)
      required_parameters :user_id, :destination_phone_number

      let!(:user) { create(:member, :premium, pha: pha) }
      let(:user_id) { user.id }
      let(:destination_phone_number) { '5553334444' }
      let(:raw_post) { params.to_json }

      example_request '[POST] Create a phone call' do
        explanation 'Create a new phone call'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        phone_call = PhoneCall.find(body[:phone_call][:id])
        expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
        expect(phone_call).to be_outbound
        expect(phone_call.user).to eq(user)
        expect(phone_call.creator).to eq(pha)
        expect(phone_call.destination_phone_number).to eq('5553334444')
      end
    end

    describe 'outbound phone call' do
      let!(:phone_call) { create(:phone_call, dialer: pha, outbound: true) }

      post '/api/v1/phone_calls/:id/connect/origin' do
        parameter :id, 'Phone call id'

        let(:id) { phone_call.id }
        let(:raw_post) { params.to_json }

        example_request '[POST] Indicates phone call\'s origin connected' do
          explanation 'Dials the destination'
          expect(status).to eq(200)
          phone_call.reload
          expect(phone_call.destination_twilio_sid).to eq('FAKETWILIOSID')
          expect(phone_call.origin_status).to eq(PhoneCall::CONNECTED_STATUS)
        end
      end

      post '/api/v1/phone_calls/:id/connect/destination' do
        parameter :id, 'Phone call id'

        let(:id) { phone_call.id }
        let(:raw_post) { params.to_json }

        example_request '[POST] Indicates phone call\'s destination connected' do
          explanation 'and that\s it.'
          expect(status).to eq(200)
          phone_call.reload
          expect(phone_call.destination_status).to eq(PhoneCall::CONNECTED_STATUS)
        end
      end
    end

    describe 'inbound PHA phone call' do
      let!(:phone_call) { create(:phone_call, to_role: Role.pha, origin_phone_number: '4083913578') }

      post '/api/v1/phone_calls/connect' do
        parameter :From, 'Phone # of inbound caller'
        parameter :CallSid, 'Twilio call SID'
        required_parameters :From, :CallSid

        let(:From) { phone_call.origin_phone_number }
        let(:CallSid) { 'CA8f68d3676b5424bde1594cb34235076b' }
        let(:raw_post) { params.to_json }

        example_request '[POST] Determine how to route the phone call.' do
          explanation 'Twilio telling us that a phone connected and we need to route it properly.'
          expect(status).to eq(200)
          expect(phone_call.reload).to be_unclaimed
        end
      end
    end

    describe 'inbound Nurse phone call' do
      let!(:phone_call) { create(:phone_call, to_role: nurse_role, origin_phone_number: '4083913578') }

      post '/api/v1/phone_calls/connect/nurse' do
        parameter :From, 'Phone # of inbound caller'
        parameter :CallSid, 'Twilio call SID'
        required_parameters :From, :CallSid

        let(:From) { phone_call.origin_phone_number }
        let(:CallSid) { 'CA8f68d3676b5424bde1594cb34235076b' }
        let(:raw_post) { params.to_json }

        example_request '[POST] Determine how to route the nurseline phone call.' do
          explanation 'Twilio telling us that a nurseline phone connected and we need to route it properly.'
          expect(status).to eq(200)
          expect(phone_call.reload).to be_unclaimed
        end
      end
    end

    describe 'triage menu' do
      let!(:phone_call) { create(:phone_call, to_role: nurse_role, origin_phone_number: '4083913578') }

      get '/api/v1/phone_calls/:id/triage/menu' do
        parameter :id, 'Phone call id'
        required_parameters :id

        let(:id) { phone_call.id }

        example_request '[GET] triage menu.' do
          explanation 'The triage menu for the inbound caller.'
          expect(status).to eq(200)
        end
      end

      post '/api/v1/phone_calls/:id/triage/select' do
        parameter :Digits, 'Phone call id'
        parameter :id, 'Phone call id'
        required_parameters :id, :Digits

        let(:id) { phone_call.id }
        let(:Digits) { '*' }
        let(:raw_post) { params.to_json }

        example_request "[POST] Caller's selection from the triage menu" do
          explanation 'The caller selected an option from the triage menu, process it.'
          expect(status).to eq(200)
          expect(phone_call.reload).to be_missed
          phone_call_task = phone_call.phone_call_task
          expect(phone_call_task).to be_abandoned
          task_change = TaskChange.last
          expect(task_change.reason).to eq('after_hours')
          xml = Nokogiri::XML(response_body)
          xml.xpath('//Response/Play').text().should =~ /goodbye.aiff/
        end
      end
    end

    describe 'status' do
      context 'new phone call' do
        let!(:phone_call) { create(:phone_call, to_role: nurse_role, origin_phone_number: '4083913578') }

        post '/api/v1/phone_calls/:id/status/origin' do
          parameter :id, 'Phone call id'
          parameter :CallStatus, 'Status of the call'

          let(:id) { phone_call.id }
          let(:CallStatus) { 'completed' }
          let(:raw_post) { params.to_json }

          example_request '[POST] Update the status of a phone call best on the origin\'s call status' do
            explanation 'Twilio telling us that the origin\'s call status has changed'
            expect(status).to eq(200)
            phone_call.reload
            expect(phone_call).to be_missed
            expect(phone_call.origin_status).to eq('completed')
          end
        end

        post '/api/v1/phone_calls/:id/status/destination' do
          parameter :id, 'Phone call id'
          parameter :CallStatus, 'Status of the call'

          let(:id) { phone_call.id }
          let(:CallStatus) { 'completed' }
          let(:raw_post) { params.to_json }

          example_request '[POST] Update the status of a phone call best on the destination\'s call status' do
            explanation 'Twilio telling us that the destination\'s call status has changed'
            expect(status).to eq(200)
            phone_call.reload
            expect(phone_call).to be_missed
            expect(phone_call.destination_status).to eq('completed')
          end
        end
      end

      context 'resolved inbound phone call' do
        let(:phone_call) do
          create(:phone_call,
                 to_role: Role.pha,
                 origin_phone_number: '4083913578',
                 origin_twilio_sid: 'OTHERFAKETWILIOSID')
          .tap{|pc| pc.resolve!}
        end

        post '/api/v1/phone_calls/status' do
          parameter :CallSid, 'Twilio SID of the call'
          parameter :CallStatus, 'Status of the call'

          let(:CallSid) { phone_call.origin_twilio_sid }
          let(:CallStatus) { 'completed' }
          let(:raw_post) { params.to_json }

          example_request '[POST] Update the status of a phone call' do
            explanation 'Twilio telling us that a phone call has changed in status'
            expect(status).to eq(200)
            phone_call.reload
            expect(phone_call).to be_missed
            expect(phone_call.origin_status).to eq('completed')
          end
        end

        put '/api/v1/phone_calls/:id/hang_up' do
          parameter :id, 'Phone call id'
          required_parameters :id

          let(:id) { phone_call.id }
          let(:raw_post) { params.to_json }

          example_request '[PUT] Hang up a phone call' do
            explanation 'Hang up a phone call'
            expect(status).to eq(200)
            body = JSON.parse(response_body, symbolize_names: true)
            expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
          end
        end
      end

      describe 'transferring calls' do
        let!(:nurse_role) { create(:role, name: 'nurse') }
        let!(:phone_call) { create(:phone_call, to_role: Role.pha) }

        put '/api/v1/phone_calls/:id/transfer' do
          parameter :id, 'Phone call id'
          required_parameters :auth_token, :id

          let(:id) { phone_call.id }
          let(:raw_post) { params.to_json }

          example_request '[PUT] Transfers the phone call to nurseline' do
            explanation 'Transfer a phone call to nurseline'
            expect(status).to eq(200)
            body = JSON.parse(response_body, symbolize_names: true)
            phone_call.reload
            expect(body[:phone_call].to_json).to eq(phone_call.serializer.as_json.to_json)
            expect(phone_call.transferred_to_phone_call).to be_present
            expect(phone_call.transferred_to_phone_call.to_role).to eq(nurse_role)
          end
        end

        put '/api/v1/phone_calls/:id/merge' do
          parameter :id, 'Phone call id'
          parameter :caller_id, 'Account to merge phone call into'
          required_parameters :id, :caller_id

          let!(:user) { pha }
          let!(:member) { create :member }
          let!(:phone_call) { create(:phone_call,:with_message, state: :claimed, to_role: Role.pha, user: nil, message: nil) }
          let!(:unresolved_phone_call) { create(:phone_call, :with_message, state: :unresolved, to_role: Role.pha, user: member) }
          let(:id) { phone_call.id }
          let(:caller_id) { member.id }
          let(:raw_post) { params.to_json }

          example_request '[PUT] Merge a phone call with a member' do
            explanation 'Merges a phone number with a member by merging an unresolved phone call or adding the member to the phone call'
            expect(status).to eq(200)
            unresolved_phone_call.reload
            expect(unresolved_phone_call).to be_merged
            expect(unresolved_phone_call.merged_into_phone_call_id).to eq(phone_call.id)
            body = JSON.parse(response_body, symbolize_names: true)
            expect(body[:phone_call].to_json).to eq(phone_call.reload.serializer.as_json.to_json)
          end
        end
      end
    end
  end
end
