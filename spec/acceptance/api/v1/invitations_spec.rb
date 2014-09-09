require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Invitations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:admin) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let!(:invitation) { create(:invitation) }

  describe 'create invitation' do
    parameter :auth_token, 'Performing admin\'s auth_token'
    parameter :email, 'Email of HCP to invite'
    parameter :first_name, 'First name of HCP to invite'
    parameter :last_name, 'Last name of HCP to invite'

    required_parameters :auth_token, :email
    scope_parameters :user, [:email, :first_name, :last_name]

    let(:auth_token) { session.auth_token }
    let(:email) { 'nurse@example.com' }
    let(:first_name) { 'Florence' }
    let(:last_name) { 'Nightingale' }

    let(:raw_post) { params.to_json }

    post '/api/v1/invitations/' do
      example_request '[POST] Invite a HCP' do
        explanation 'Invite a HCP (Invitor must be an admin)'
        status.should == 200
      end
    end
  end

  describe 'invitation' do
    parameter :token, 'Invitation token'

    required_parameters :token

    let(:token) { invitation.token }

    get '/api/v1/invitations/:token' do
      example_request '[GET] Invitation' do
        explanation 'Retrieve an invitation by it\'s token. Also adds invitor and invitee names.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:invitation].to_json.should == invitation.as_json(
          :only => [:token],
          :include => {
            :member => {
              :only => [],
              :methods => [:full_name]
            },
            :invited_member => {
              :only => [:email, :first_name, :last_name],
              :methods => :nurse?
            }
          }
        ).to_json
      end
    end
  end

  describe 'sign up via invitation' do
    parameter :token, 'Invitation token'
    parameter :email, 'Email of HCP to invite'
    parameter :first_name, 'First name of HCP to invite'
    parameter :last_name, 'Last name of HCP to invite'
    parameter :password, 'Last name of HCP to invite'
    parameter :password_confirmation, 'Last name of HCP to invite'

    required_parameters :token, :email, :first_name, :last_name, :password, :password_confirmation
    scope_parameters :user, [:email, :first_name, :last_name, :password, :password_confirmation]

    let(:token) { invitation.token }
    let(:email) { 'nurse@example.com' }
    let(:first_name) { 'Florence' }
    let(:last_name) { 'Nightingale' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }

    let(:raw_post) { params.to_json }

    put '/api/v1/invitations/:token' do
      example_request '[PUT] Sign Up via Invitation' do
        explanation 'Retrieve an invitation by it\'s token. Also adds invitor and invitee names.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        new_user = Member.last
        response[:auth_token].should == new_user.sessions.first.auth_token
        response[:user].to_json.should == new_user.serializer.as_json.to_json
      end
    end
  end
end
