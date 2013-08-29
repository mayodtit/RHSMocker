require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:correct_password) { 'some_password' }
  let(:user) { create(:user_with_email, :password => correct_password,
                                        :password_confirmation => correct_password).tap{|u| u.login} }

  describe 'create session with email and password' do
    parameter :email, "User's email address"
    parameter :password, "User's password"
    required_parameters :email, :password

    let(:email) { user.email }
    let(:password) { correct_password }
    let(:raw_post) { params.to_json }

    post '/api/v1/login' do
      example_request "[POST] Sign in using email and password" do
        explanation "Returns auth_token and the user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        response[:auth_token].should == user.reload.auth_token
        response[:user].to_json.should == user.as_json.to_json
      end
    end
  end

  delete '/api/v1/logout' do
    parameter :auth_token, "User's auth token"
    required_parameters :auth_token

    let(:auth_token) { user.auth_token }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Sign out" do
      explanation "Signs out the user specified by the auth_token"
      status.should == 200
    end
  end
end
