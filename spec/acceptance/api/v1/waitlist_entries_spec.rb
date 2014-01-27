require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "WaitlistEntries" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  context 'existing record' do
    let!(:waitlist_entry) { create(:waitlist_entry) }
    let(:admin) { create(:admin) }
    let(:auth_token) { admin.auth_token }

    parameter :auth_token, "Admin's auth_token"
    required_parameters :auth_token

    get '/api/v1/waitlist_entries' do
      example_request '[GET] Get all waitlist_entries' do
        explanation 'Index all existing waitlist_entries'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:waitlist_entries].to_json).to eq([waitlist_entry].as_json.to_json)
      end
    end
  end

  post '/api/v1/waitlist_entries' do
    parameter :email, 'email address to be added to waitlist'
    let(:email) { 'email@test.getbetter.com' }
    let(:raw_post) { params.to_json }

    example_request "[POST] Add an email to the wait list" do
      explanation "Creates a waitlist_entry"
      status.should == 200
      body = JSON.parse(response_body, :symbolize_names => true)
      WaitlistEntry.find(body[:waitlist_entry][:id]).email.to_json.should == email.to_json
    end
  end
end
