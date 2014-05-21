require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Roles" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:pha_lead) }
  let!(:pha_lead) { create(:pha_lead) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  describe 'show' do
    parameter :auth_token, 'Performing user\'s auth_token'
    parameter :id, 'Name of role to get'

    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id) { user.roles.first.name }

    get '/api/v1/roles/:id' do
      example_request '[GET] Get a role' do
        explanation 'Given all members by role (which is specified by name). Accessible only by PHA leads.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:role].to_json.should == user.roles.first.serializer.as_json.to_json
      end
    end
  end

  describe 'members' do
    parameter :auth_token, 'Performing user\'s auth_token'
    parameter :id, 'Name of role to filter members by'

    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id) { user.roles.first.name }

    get '/api/v1/roles/:id/members' do
      example_request '[GET] Get all members by role' do
        explanation 'Given all members by role (which is specified by name). Accessible only by PHA leads.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:members].to_json.should == [user, pha_lead].serializer.as_json.to_json
      end
    end
  end
end
