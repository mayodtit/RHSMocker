require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Entries" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'


  let!(:pha) { create(:pha) }
  let!(:member) { create :member, pha: pha }
  let(:session) { pha.sessions.create }
  let(:auth_token) { pha.auth_token }

  let!(:entry) { create :entry, member: member }
  let!(:another_entry) { create :entry, member: member, actor: pha }
  let!(:seperate_entry) { create :entry, member: pha }

  describe 'entries' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'Member to retrieve entries for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { member.id }

    get '/api/v1/members/:member_id/entries/' do
      example_request '[GET] Get all entries for a member' do
        explanation 'Get all entries for a member'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:entries].to_json.should == [entry, another_entry].serializer(timeline: true).to_json
      end
    end
  end
end
