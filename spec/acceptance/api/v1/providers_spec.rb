require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Providers' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let(:provider) {
                   {
                     first_name: 'Kyle',
                     last_name: 'Chilcutt',
                     npi_number: '0123456789',
                     address: 
                     {
                       address: '1337 Leet St',
                       address2: '1337 Leet St',
                       city: 'San Francisco',
                       state: 'CA',
                       postal_code: '941337',
                       country_code: '1',
                       phone: '6666666666',
                       fax: '6666666666'
                     },
                     city: 'San Francisco',
                     state: 'CA',
                     phone: '6666666666',
                     expertise: 'Counterfeiting Medical Credentials',
                     gender: 'male',
                     healthcare_taxonomy_code: "207RC0001X",
                     provider_taxonomy_code: "207RC0001X",
                     taxonomy_classification: 'A'
                   }
                 }
  before do
    Search::Service.any_instance.stub(query: [provider])
  end

  parameter :auth_token, "Member's auth_token"
  parameter :npi, "NPI number of provider"
  parameter :first_name, "First name of provider"
  parameter :last_name, "Last name of provider"
  parameter :state, "State the provider resides in"
  parameter :zip, "Zip code the provider resides in"
  parameter :city, "City the provider resides in"
  parameter :dist, "Size of the search radius in miles"
  required_parameters :auth_token

  get '/api/v1/providers/search' do
    example_request '[GET] Get list of users from external source (e.g. NPI database)' do
      explanation 'Returns an array of Users that match the parameters'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:providers].to_json).to eq([provider].as_json.to_json)
    end
  end
end
