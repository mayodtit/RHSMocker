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

  describe 'members' do
    parameter :auth_token, 'Performing user\'s auth_token'
    parameter :role_name, 'Name of role to filter members by'

    required_parameters :auth_token, :role_name

    let(:auth_token) { user.auth_token }
    let(:role_name) { user.roles.first.name }

    get '/api/v1/roles/:role_name/members' do
      example_request '[GET] Get all members by role' do
        explanation 'Given all members by role (which is specified by name). Accessible only by PHA leads.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:members].to_json.should == [user, pha_lead].as_json.to_json
      end
    end
  end
end
