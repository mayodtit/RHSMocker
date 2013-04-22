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
    @content = FactoryGirl.create(:content)
    @user_reading = FactoryGirl.create(:user_reading, :user=>@user, :content=>@content, :read_date=>DateTime.now())

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
    parameter :image_url,   "User's image URL"
    parameter :gender,   "User's gender(male or female)"
    parameter :height,   "User's height(in cm)"
    parameter :birth_date,   "User's birth date"
    parameter :phone,   "User's phone number"
    parameter :generic_call_time,   "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket,   "User's feature bucket (none message_only call_only message_call)"
    scope_parameters :user, [:install_id, :email, :password, :feature_bucket, :first_name, :last_name, :image_url, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket]

    required_parameters :install_id, :email, :password

    let (:install_id)     { "1234" }
    let (:email)          { "tst@test.com" }
    let (:password)       { "11111111" }
    let (:feature_bucket) { "message_only" }
    let (:first_name)     { "Bob" }
    let (:last_name)      { "Smith" }
    let (:image_url)      { "http://placekitten.com/90/90" }
    let (:gender)      { "male" }
    let (:height)      { 190 }
    let (:birth_date)      { "1980-10-15" }
    let (:phone)      { "4163442356" }
    let (:generic_call_time)      { "morning" }
    let (:feature_bucket)      { "none" }
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
    parameter :email,       "Account email"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"
    parameter :first_name,  "User's first name"
    parameter :last_name,   "User's last name"
    parameter :image_url,   "User's image URL"
    parameter :gender,   "User's gender(male or female)"
    parameter :height,   "User's height(in cm)"
    parameter :birth_date,   "User's birth date"
    parameter :phone,   "User's phone number"
    parameter :generic_call_time,   "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket,   "User's feature bucket (none message_only call_only message_call)"
    scope_parameters :user, [:email, :first_name, :last_name, :image_url, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket]

    required_parameters :auth_token

    let (:email)          { "tst111@test.com" }
    let (:feature_bucket) { "message_only" }
    let (:first_name)     { "Bob" }
    let (:last_name)      { "Smith" }
    let (:image_url)      { "http://placekitten.com/90/90" }
    let (:gender)      { "male" }
    let (:height)      { 190 }
    let (:birth_date)      { "1980-10-15" }
    let (:phone)      { "4163442356" }
    let (:generic_call_time)      { "morning" }
    let (:feature_bucket)      { "none" }
    let (:auth_token)    { @user.auth_token }


    let (:raw_post)      { params.to_json }  # JSON format request body

    example_request "[PUT] Update user" do
      explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

  put '/api/v1/user/:id' do
    parameter :auth_token,    "User's auth token"
    parameter :id,          "ID of user to update"
    parameter :email,       "Account email"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"
    parameter :first_name,  "User's first name"
    parameter :last_name,   "User's last name"
    parameter :image_url,   "User's image URL"
    parameter :gender,   "User's gender(male or female)"
    parameter :height,   "User's height(in cm)"
    parameter :birth_date,   "User's birth date"
    parameter :phone,   "User's phone number"
    parameter :generic_call_time,   "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket,   "User's feature bucket (none message_only call_only message_call)"
    scope_parameters :user, [:email, :first_name, :last_name, :image_url, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket]

    required_parameters :auth_token, :id

    let (:id)         { @user.associates.first.id }
    let (:email)          { "tst121@test.com" }
    let (:feature_bucket) { "message_only" }
    let (:first_name)     { "Bob" }
    let (:last_name)      { "Smith" }
    let (:image_url)      { "http://placekitten.com/90/90" }
    let (:gender)      { "male" }
    let (:height)      { 190 }
    let (:birth_date)      { "1980-10-15" }
    let (:phone)      { "4163442356" }
    let (:generic_call_time)      { "morning" }
    let (:feature_bucket)      { "none" }
    let (:auth_token)    { @user.auth_token }
    let (:raw_post)      { params.to_json }  # JSON format request body

    example_request "[PUT] Update a specific user" do
      explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
      status.should == 200
      JSON.parse(response_body)['user'].should_not be_empty
    end
  end

   post '/api/v1/feedback' do
    parameter :auth_token,    "User's auth token"
    parameter :note,          "Note to be sent as feedback"

    required_parameters :auth_token, :note

    let (:auth_token)       { @user.auth_token }
    let (:note) { "this is awesome" }
    let (:raw_post)         { params.to_json }  # JSON format request body

    example_request "[POST] Add feedback" do
      explanation "Adds feedback from the user"
      status.should == 200
      JSON.parse(response_body)['feedback'].should_not be_empty
    end
  end

end
