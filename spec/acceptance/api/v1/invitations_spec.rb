require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Invitations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:phone_call) { create(:phone_call) }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing hcp's auth_token"
  required_parameters :auth_token
end