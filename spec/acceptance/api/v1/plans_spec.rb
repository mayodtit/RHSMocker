require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Plans' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let!(:plan) { create(:plan, :with_offering) }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/plans' do
    example_request '[GET] Retreive all available plans' do
      explanation 'Returns an array of addable plans'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end
end
