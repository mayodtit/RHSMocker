require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ScheduledPhoneCalls" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:consult) { create(:consult, :initiator => user) }
  let(:consult_id) { consult.id }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  context 'existing record' do
    let!(:scheduled_phone_call) { create(:scheduled_phone_call) }
    let!(:message) { create(:message, :user => user,
                                      :consult => consult,
                                      :scheduled_phone_call => scheduled_phone_call) }
    let(:id) { scheduled_phone_call.id }

    get '/api/v1/consults/:consult_id/scheduled_phone_calls' do
      example_request "[GET] Get all scheduled_phone_calls for a given user" do
        explanation "Returns an array of scheduled_phone_calls"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:scheduled_phone_calls]
        body.should be_a Array
        body.should_not be_empty
      end
    end

    get '/api/v1/consults/:consult_id/scheduled_phone_calls/:id' do
      example_request "[GET] Get a scheduled_phone_call for a given user" do
        explanation "Returns the scheduled_phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:scheduled_phone_call]
        body.should be_a Hash
        body[:id].should == scheduled_phone_call.id
      end
    end

    put '/api/v1/consults/:consult_id/scheduled_phone_calls/:id' do
      let(:scheduled_at) { Time.now + 1.day }

      parameter :scheduled_at, 'Time for when the call is scheduled'

      let(:raw_post) { params.to_json }

      example_request "[PUT] Update a scheduled_phone_call" do
        explanation "Updates and returns the scheduled_phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:scheduled_phone_call]
        body.should be_a Hash
        body[:id].should == scheduled_phone_call.id
      end
    end

    delete '/api/v1/consults/:consult_id/scheduled_phone_calls/:id' do
      let(:raw_post) { params.to_json }

      example_request "[DELETE] Cancel a scheduled_phone_call" do
        explanation "Cancels the scheduled_phone_call"
        status.should == 200
      end
    end
  end

  post '/api/v1/consults/:consult_id/scheduled_phone_calls' do
    let(:scheduled_at) { Time.now + 1.day }

    parameter :scheduled_at, 'Time for when the call is scheduled'

    let(:raw_post) { params.to_json }

    example_request "[POST] Create a scheduled_phone_call" do
      explanation "Creates a scheduled_phone_call"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:scheduled_phone_call]
      body.should be_a Hash
      ScheduledPhoneCall.find(body[:id]).scheduled_at.to_json.should == scheduled_at.utc.to_json
    end
  end
end
