require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @password = 'some_password'
    @user_with_email = FactoryGirl.create(:user_with_email, :password=>@password, :password_confirmation=>@password)
    @user = FactoryGirl.create(:user)
  end

  post '/api/v1/login' do
    parameter :email,       "User's email address"
    parameter :password,    "User's password"
    required_parameters :email, :password

    let (:email)    { @user_with_email.email }
    let (:password) { @password }
    let (:raw_post) { params.to_json }  # JSON format request body

    example_request "Sign In using Email and Password" do
      explanation "Return auth_token on success"

      status.should == 200
      JSON.parse(response_body)['auth_token'].should_not be_empty
    end
  end

  post '/api/v1/login' do
    parameter :install_id,  "Unique install_id" 
    required_parameters :install_id

    let (:install_id) { @user.install_id }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Sign In using install_id" do
      explanation "Auto login if install_id doesn't exist"

      status.should == 200
      JSON.parse(response_body)['auth_token'].should_not be_empty
    end
  end

end
