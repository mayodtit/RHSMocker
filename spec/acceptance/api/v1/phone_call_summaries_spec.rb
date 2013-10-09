require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "PhoneCallSummaries" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:phone_call_summary) { create(:phone_call_summary) }
  let(:user) { phone_call_summary.callee }
  let(:auth_token) { user.auth_token }
  let(:id) { phone_call_summary.id }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/phone_call_summaries/:id' do
    parameter :id, 'id of the PhoneCallSummary to retrieve'
    required_parameters :id

    example_request "[GET] Get a phone_call_summary for a given user" do
      explanation "Returns the phone_call_summary"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)[:phone_call_summary]
      body.should be_a Hash
      body[:id].should == phone_call_summary.id
    end
  end
end
