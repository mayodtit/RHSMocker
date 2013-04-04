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

    @user2 = FactoryGirl.create(:associate)
    @association = FactoryGirl.create(:association, :user=>@user, :associate=>@user2)
  end

  get '/api/v1/user/keywords' do
    parameter :auth_token,      "User's Auth token"
    required_parameters :auth_token

    let (:auth_token)       { @user.auth_token }

    example_request "[GET] Get user's keywords (search history)" do
      explanation "[Implementation incomplete] Returns an array of keywords"
      status.should == 200
      JSON.parse(response_body)['keywords'].should be_a Array
    end
  end

  post '/api/v1/signup' do
    parameter :install_id, "Unique install ID"
    scope_parameters :user, [:install_id]

    required_parameters :install_id

    let (:install_id) { "1234" }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Sign up using install ID" do
      explanation "Returns auth_token and the user"

      status.should == 200
      response = JSON.parse(response_body)
      response['auth_token'].should_not be_empty
      response['user'].should_not be_empty
    end
  end

  post '/api/v1/signup' do
    parameter :install_id,  "Unique install ID"
    parameter :email,       "Account email"
    parameter :password,    "Account password"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"
    parameter :first_name,  "User's first name"
    parameter :last_name,   "User's last name"
    scope_parameters :user, [:install_id, :email, :password, :feature_bucket, :first_name, :last_name]

    required_parameters :install_id, :email, :password

    let (:install_id)     { "1234" }
    let (:email)          { "tst@test.com" }
    let (:password)       { "11111111" }
    let (:feature_bucket) { "message_only" }
    let (:first_name)     { "Bob" }
    let (:last_name)      { "Smith" }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[POST] Sign up using email and password (or add email and password to account)" do
      explanation "If the install ID exists, update that user's account with email and password.  Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns auth_token and the user."

      status.should == 200
      response = JSON.parse(response_body)
      response['auth_token'].should_not be_empty
      response['user'].should_not be_empty
    end
  end

  post '/api/v1/user/update_email' do
    parameter :auth_token,        "User's auth token"
    parameter :password,          "User's password; for verification"
    parameter :email,             "New email address"

    required_parameters :auth_token, :password, :email

    let (:auth_token)       { @user.auth_token }
    let (:password)         { @password }
    let (:email)            { 'new_email@address.com' }
    let (:raw_post)         { params.to_json }  # JSON format request body

    example_request "[POST] Change the email" do
      explanation "Returns the user"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

  post '/api/v1/user/update_password' do
    parameter :auth_token,        "User's auth token"
    parameter :current_password,  "User's current password"
    parameter :password,          "New account password"

    required_parameters :auth_token, :current_password, :password

    let (:auth_token)       { @user.auth_token }
    let (:current_password) { @password }
    let (:password)         { "new_password" }
    let (:raw_post)         { params.to_json }  # JSON format request body

    example_request "[POST] Change the password" do
      explanation "Returns the user"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

  put '/api/v1/user' do
    parameter :auth_token,    "User's auth token"
    parameter :first_name,    "User's first name"
    parameter :phone,         "User's phone number"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"

    scope_parameters :user, [:phone, :first_name, :feature_bucket]
    required_parameters :auth_token

    let (:auth_token)    { @user.auth_token }
    let (:first_name)    { "Batman" }
    let (:phone)         { "1234567890" }
    let (:feature_bucket) { "message_only" }
    let (:raw_post)      { params.to_json }  # JSON format request body

    example_request "[PUT] Update user (temporary allow changes to password field)" do
      explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

  put '/api/v1/user/:id' do
    parameter :auth_token,  "User's auth token"
    parameter :id,          "ID of user to update"
    parameter :first_name,  "User's first name"
    parameter :phone,       "User's phone number"

    scope_parameters :user, [:phone, :first_name]
    required_parameters :auth_token, :id

    let (:auth_token) { @user.auth_token }
    let (:id)         { @user.associates.first.id }
    let (:first_name) { "Robin" }
    let (:phone)      { "2234567890" }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "[PUT] Update a specific user" do
      explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

end
