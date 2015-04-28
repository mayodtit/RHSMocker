require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Entries" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'


  let!(:pha) { create(:pha) }
  let!(:member) { create :member, pha: pha }
  let(:session) { pha.sessions.create }
  let(:auth_token) { pha.auth_token }


  parameter :auth_token, 'Performing hcp\'s auth_token'
  parameter :member_id, 'Member to retrieve entries for'

  required_parameters :auth_token, :member_id

  let(:auth_token) { session.auth_token }
  let(:member_id) { member.id }

  context 'entries' do
    let!(:entry) { create :entry, member: member }
    let!(:another_entry) { create :entry, member: member }
    let!(:seperate_entry) { create :entry, member: pha }

    get '/api/v1/members/:member_id/entries/' do
      example_request '[GET] Get all entries for a member' do
        explanation 'Get all entries for a member'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:entries].to_json.should == [entry, another_entry].serializer.to_json
      end
    end
  end

  context 'entries with pagination' do
    let!(:first_entry) { create(:entry, member: member) }
    let!(:second_entry) { create(:entry, member: member) }
    let!(:third_entry) { create(:entry, member: member) }
    let!(:fourth_entry) { create(:entry, member: pha) }
    let!(:fifth_entry) { create(:entry, member: member) }

    get '/api/v1/members/:member_id/entries' do
      parameter :after, 'filters for entries with ids after, but not including the specified integer id'
      parameter :offset, 'integer offset for the pagination by this amount'
      parameter :page,'integer page number, indexed starting from 1'
      parameter :per, 'integer size of pages'

      let!(:offset) {1}
      let!(:page) {1}
      let!(:per) {5}
      example_request "[GET] Get paginated entries for a member" do
        explanation "Returns an array of entries"
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:entries].map {|i| i[:id]}).to include(first_entry.id, second_entry.id, third_entry.id)
        expect(body[:entries].map {|i| i[:id]}).not_to include(fourth_entry.id)
        expect(body[:entries].size).to eql(3)
        expect(body[:total_count]).to eql(4)
      end
    end
  end
end
