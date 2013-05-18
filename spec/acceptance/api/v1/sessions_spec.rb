require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @password = 'some_password'
    @user_with_email = FactoryGirl.create(:user_with_email, :password=>@password, :password_confirmation=>@password)
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user2.login
  end

  describe 'create session with email and password' do
    parameter :email,       "User's email address"
    parameter :password,    "User's password"
    required_parameters :email, :password

    post '/api/v1/login' do
      let (:email)    { @user_with_email.email }
      let (:password) { @password }
      let (:raw_post) { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using email and password" do
        explanation "Returns auth_token and the user"

        status.should == 200
        response = JSON.parse(response_body)
        response['auth_token'].should_not be_empty
        response['user'].should_not be_empty
      end
    end

    post '/api/v1/login' do
      let (:email)    { @user_with_email.email }
      let (:password) { 'wrong password' }
      let (:raw_post) { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using email and password b (401)" do
        explanation "Returns auth_token and the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

  describe 'create session with email and password, and merge visitor account with full existing account' do
    parameter :email,       "User's email address"
    parameter :password,    "User's password"
    parameter :auth_token,    "Visitor's auth_token"
    required_parameters :email, :password, :auth_token

    post '/api/v1/login' do
      let (:email)    { @user_with_email.email }
      let (:password) { @password }
      let (:auth_token) { @user2.auth_token }
      let (:raw_post) { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using email and password and merge a visitor account" do
        explanation "Returns auth_token and the user"
        status.should == 200
        response = JSON.parse(response_body)
        response['auth_token'].should_not be_empty
        response['user'].should_not be_empty
      end
    end
    
    post '/api/v1/login' do
      let (:email)    { @user_with_email.email }
      let (:password) { 'wrong password' }
      let (:auth_token) { @user2.auth_token }
      let (:raw_post) { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using email and password and merge a visitor account b (401)" do
        explanation "Returns auth_token and the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

  describe 'create session with install ID' do
    parameter :install_id,  "Unique install id" 
    required_parameters :install_id

    post '/api/v1/login' do
      let (:install_id) { @user.install_id }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using install id" do
        explanation "Only works if the user's email isn't set up; Returns auth_token and the user"

        status.should == 200
        response = JSON.parse(response_body)
        response['auth_token'].should_not be_empty
        response['user'].should_not be_empty
      end
    end

    post '/api/v1/login' do
      let (:install_id) { 123456789 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Sign in using install id b (401)" do
        explanation "Only works if the user's email isn't set up; Returns auth_token and the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

  delete '/api/v1/logout' do
    parameter :auth_token,   "User's auth token"
    required_parameters :auth_token

    let (:auth_token)       { User.find_by_id(@user.id).auth_token }
    let (:raw_post)         { params.to_json }  # JSON format request body

    example_request "[DELETE] Sign out" do
      explanation "Signs out the user specified by the auth_token"
      status.should == 200
      JSON.parse(response_body)
    end
  end

end
