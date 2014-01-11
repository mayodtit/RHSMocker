require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "WaitlistEntries" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

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
