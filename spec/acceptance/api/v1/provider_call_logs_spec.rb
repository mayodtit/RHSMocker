require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'ProviderCallLogs' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }

  describe 'create provider phone call log entry' do
    parameter :auth_token, "User's auth token"
    parameter :npi,        "Provider's NPI"
    parameter :number,     'Number dialed'
    parameter :user_id,    "Caller's user_id"
    required_parameters :npi, :number, :user_id

    post '/api/v1/provider_call_logs' do
      let(:auth_token) { user.auth_token }
      let(:user_id)    { user.id }
      let(:npi)        { '0987654321' }
      let(:number)     { '1234567890' }
      let(:raw_post)   { params.to_json }

      example_request '[POST] Create a provider phone call log entry' do
        explanation 'Create a provider phone call log entry and return the created entry'
        status.should == 200
        response = JSON.parse(response_body)['provider_call_log']
        expect(response['npi']).to eq('0987654321')
        expect(response['number']).to eq(1234567890)
        expect(response['user_id']).to eq(user.id)
      end
    end
  end
end
