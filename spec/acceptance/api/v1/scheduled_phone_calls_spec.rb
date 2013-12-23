require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ScheduledPhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:admin) }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  context 'existing record' do
    let!(:scheduled_phone_call) { create(:scheduled_phone_call) }
    let(:id) { scheduled_phone_call.id }

    get '/api/v1/scheduled_phone_calls' do
      example_request "[GET] Get all scheduled_phone_calls" do
        explanation "Returns an array of scheduled_phone_calls"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)
        body[:scheduled_phone_calls].to_json.should == [scheduled_phone_call].serializer.to_json
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

    delete '/api/v1/scheduled_phone_calls/:id' do
      let(:raw_post) { params.to_json }

      example_request "[DELETE] Cancel a scheduled_phone_call" do
        explanation "Cancels the scheduled_phone_call"
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
