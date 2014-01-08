require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ConsultPhoneCalls" do
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
    let!(:phone_call) { create(:phone_call) }
    let!(:message) { create(:message, :user => user,
                                      :consult => consult,
                                      :phone_call => phone_call) }
    let(:id) { phone_call.id }

    get '/api/v1/consults/:consult_id/phone_calls' do
      example_request "[GET] Get all phone_calls for a given user" do
        explanation "Returns an array of phone_calls"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:phone_calls]
        body.should be_a Array
        body.should_not be_empty
      end
    end

    get '/api/v1/consults/:consult_id/phone_calls/:id' do
      example_request "[GET] Get a phone_call for a given user" do
        explanation "Returns the phone_call"
        status.should == 200
        body = JSON.parse(response_body, :symbolize_names => true)[:phone_call]
        body.should be_a Hash
        body[:id].should == phone_call.id
      end
    end
  end

  post '/api/v1/consults/:consult_id/phone_calls' do
    parameter :origin_phone_number, 'Phone number making the call'
    parameter :destination_phone_number, 'Phone number where the call is directed'

    scope_parameters :phone_call, [:origin_phone_number, :destination_phone_number, :to_role]

    let(:to_role) { user.roles.first.name }
    let(:origin_phone_number) { '555-123-4567' }
    let(:destination_phone_number) { '555-888-8888' }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create a phone_call" do
      explanation "Creates a phone_call"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:phone_call]
      body.should be_a Hash
      PhoneCall.find(body[:id]).should_not be_nil
    end
  end
end
