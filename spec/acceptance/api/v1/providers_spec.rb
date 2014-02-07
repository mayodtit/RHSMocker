require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Providers' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let(:provider) {
                   {
                     first_name: 'Kyle',
                     last_name: 'Chilcutt',
                     npi_number: '0123456789',
                     city: 'San Francisco',
                     state: 'CA',
                     expertise: 'Counterfeiting Medical Credentials'
                   }
                 }

  before do
    Search::Service.any_instance.stub(query: [provider])
  end

  parameter :auth_token, "Member's auth_token"
  required_parameters :auth_token

  get '/api/v1/providers' do
    example_request '[GET] Get list of users from external source (e.g. NPI database)' do
      explanation 'Returns an array of Users that match the parameters'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:users].to_json).to eq([provider].as_json.to_json)
    end
  end
end
