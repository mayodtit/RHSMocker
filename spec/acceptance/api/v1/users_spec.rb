require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  # currently, only update_password needs user object
  before(:all) do
    @password = 'current_password'
    @user = FactoryGirl.create(:user_with_email, :password=>@password, :password_confirmation=>@password)
    @user.login
  end

  post '/api/v1/signup' do
    parameter :install_id, "Unique install_id"
    scope_parameters :user, [:install_id]

    required_parameters :install_id

    let (:install_id) { "1234" }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Signup Using install_id" do
      explanation "Signing up the user using only the install_id"

      resp = JSON.parse response_body

      status.should == 200
    end
 
  end

  post '/api/v1/signup' do
    parameter :install_id, "Unique install_id"
    parameter :email, "Account email"
    parameter :password, "Account password"
    scope_parameters :user, [:install_id, :email, :password]

    required_parameters :install_id

    let (:install_id) { "1234" }
    let (:email)      { "tst@test.com" }
    let (:password)   { "11111111" }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Signup Using Email and Password" do
      explanation "Signing up (or upgrade) the user using email"

      resp = JSON.parse response_body

      status.should == 200
    end

  end

  post '/api/v1/user/update_password' do
    parameter :auth_token,        "Auth token"
    parameter :current_password,  "User's current password"
    parameter :password,          "New account password"

    required_parameters :auth_token, :current_password, :password

    let (:auth_token)       { @user.auth_token }
    let (:current_password) { @password }
    let (:password)         { "new_password" }
    let (:raw_post)         { params.to_json }  # JSON format request body

    example_request "Change the Password" do
      explanation "Change the password for the current user"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

end
