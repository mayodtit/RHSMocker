require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "MemberServices" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:member) { create :member }
  let!(:relative) { create :user }
  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:other_pha) { create(:pha) }
  let(:auth_token) { pha.auth_token }

  let!(:service) { create :service, member: member, subject: relative }
  let!(:other_service) { create :service, member: member, subject: member }
  let!(:completed_service) { create :service, :completed, member: member, subject: relative }
  let!(:abandoned_service) { create :service, :abandoned, member: member, subject: relative }

  describe 'services' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'Member to retrieve services for'
    parameter :subject_id, 'Subject to retrieve services for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { member.id }
    let(:subject_id) { relative.id }

    get '/api/v1/members/:member_id/services/' do
      example_request '[GET] Get all services for a member' do
        explanation 'Get all services for a member (optionally filter by subject and state)'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:services].to_json.should == [service, completed_service, abandoned_service].serializer.to_json
      end
    end
  end
end
