require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Offerings' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let!(:offering) { create(:offering) }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  get '/api/v1/offerings' do
    example_request '[GET] Retreive all available offerings' do
      explanation 'Returns an array of addable offerings'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end
end
