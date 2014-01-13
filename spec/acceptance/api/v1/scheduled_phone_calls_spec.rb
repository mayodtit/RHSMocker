require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ScheduledPhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:pha_lead) }
  let!(:pha) { create(:pha) }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  context 'existing records' do
    let!(:scheduled_phone_call) { create(:scheduled_phone_call) }
    let!(:other_scheduled_phone_call) { create(:scheduled_phone_call, :scheduled_at => 3.days.ago) }
    let(:id) { scheduled_phone_call.id }

    describe 'phone_calls' do
      parameter :user_id, 'Filter by the person that is booked for the scheduled phone call.'
      parameter :owner_id, 'Filter by the HCP that owns the scheduled phone call.'
      parameter :state, 'Filter by the state of the scheduled phone call. Supports an array of states.'
      parameter :scheduled_after, 'Filter by calls after the specified date.'

      let(:scheduled_after) { Time.now }

      get '/api/v1/scheduled_phone_calls' do
        example_request "[GET] Get all scheduled_phone_calls" do
          explanation "Returns an array of scheduled_phone_calls. Can be filtered by state, user_id, owner_id and/or scheduled_after (DateTime)"
          status.should == 200
          body = JSON.parse(response_body, :symbolize_names => true)
          body[:scheduled_phone_calls].to_json.should == [scheduled_phone_call].serializer.to_json
        end
      end
    end

    get '/api/v1/scheduled_phone_calls/:id' do
      example_request "[GET] Get a scheduled_phone_call" do
        explanation "Returns the scheduled_phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:scheduled_phone_call].to_json.should == scheduled_phone_call.serializer.to_json
      end
    end

    put '/api/v1/scheduled_phone_calls/:id' do
      parameter :scheduled_at, 'Time for when the call is scheduled'
      let(:scheduled_at) { Time.now + 1.day }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Update a scheduled_phone_call" do
        explanation "Updates and returns the scheduled_phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:scheduled_phone_call][:id].should == scheduled_phone_call.id
        body[:scheduled_phone_call][:scheduled_at].to_json.should == scheduled_at.utc.to_json
      end
    end

    put '/api/v1/scheduled_phone_calls/:id/:state_event' do
      parameter :state_event, 'Time for when the call is scheduled'
      parameter :owner_id, 'If event is "assigned", specifies the HCP it\'s assigned to (required).'
      parameter :user_id, 'If the event is "booked", specifies the Member it\'s booked for(required).'

      let(:state_event) { 'assign' }
      let(:owner_id) { pha.id }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Runs a state event on a scheduled_phone_call" do
        explanation "Transitions a scheduled_phone_call's state via a state event. Events \"assigned\" and \"booked\" require additional parameters."
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:scheduled_phone_call][:id].should == scheduled_phone_call.id
        body[:scheduled_phone_call][:state].should == 'assigned'
        body[:scheduled_phone_call][:owner][:id] == pha.id
      end
    end

    delete '/api/v1/scheduled_phone_calls/:id' do
      let(:raw_post) { params.to_json }

      example_request "[DELETE] Delete a scheduled_phone_call" do
        explanation "Deletes the scheduled_phone_call"
        status.should == 200
      end
    end
  end

  post '/api/v1/scheduled_phone_calls' do
    parameter :scheduled_at, 'Time for when the call is scheduled'
    let(:scheduled_at) { Time.now + 1.day }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create a scheduled_phone_call" do
      explanation "Creates a scheduled_phone_call"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      ScheduledPhoneCall.find(body[:scheduled_phone_call][:id]).scheduled_at.to_json.should == scheduled_at.utc.to_json
    end
  end
end
