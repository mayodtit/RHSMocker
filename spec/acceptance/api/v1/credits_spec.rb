require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Credits' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let!(:credit) { create(:user_offering, :user => user) }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  let(:user_id) { user.id }
  let(:id) { credit.id }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  get '/api/v1/users/:user_id/credits' do
    example_request '[GET] Retreive all user credits' do
      explanation 'Returns an array of user credits'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end

  get '/api/v1/users/:user_id/credits/:id' do
    example_request '[GET] Retreive details for a single credit' do
      explanation 'Returns information for a single credit'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end

  get '/api/v1/users/:user_id/credits/summary' do
    example_request "[GET] Retreive summary details for a user's credits" do
      explanation 'Returns a hash of offerings and counts'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end
end
