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

    @admin_user = FactoryGirl.create(:admin, :email=>'email_exists@address.com')
    @admin_user.login

    @hcp = create(:hcp_user)
  end

  get '/api/v1/users' do
    parameter :auth_token, "User's Auth token"
    parameter :role_name, 'Optional role name for filtering'
    required_parameters :auth_token

    context 'solr query' do
      let(:q) { @hcp.first_name }
      let(:role_name) { 'hcp' }

      example_request "[GET] Get list of users filtered by name" do
        explanation "Returns an array of Users that match the name"
        status.should == 200
        JSON.parse(response_body)['users'].should be_a Array
      end
    end

    let(:auth_token) { @user.auth_token }
    let(:role_name) { 'hcp' }

    example_request "[GET] Get list of users" do
      explanation "Returns an array of Users that match the role"
      status.should == 200
      JSON.parse(response_body)['users'].should be_a Array
    end
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


  describe 'create user with install ID' do
    parameter :install_id, "Unique install ID"
    scope_parameters :user, [:install_id]
    required_parameters :install_id

    post '/api/v1/signup' do
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
      let (:install_id) { "1234" }
      let (:raw_post)   { params.to_json }  # JSON format request body
 
      example_request "[POST] Sign up using install ID (409)" do
        explanation "Returns auth_token and the user"
        status.should == 409
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'create user with email and password' do
    parameter :install_id,  "Unique install ID"
    parameter :email,       "Account email"
    parameter :password,    "Account password"
    parameter :first_name,  "User's first name"
    parameter :last_name,   "User's last name"
    parameter :image_url,   "User's image URL"
    parameter :gender,   "User's gender(male or female)"
    parameter :height,   "User's height(in cm)"
    parameter :birth_date,   "User's birth date"
    parameter :phone,   "User's phone number"
    parameter :generic_call_time,   "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket,   "User's feature bucket (none message_only call_only message_call)"
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :holds_phone_in, "The hand the user holds the phone in (left, right)"
    scope_parameters :user, [:install_id, :email, :password, :feature_bucket, :first_name, :last_name, :image_url,\
     :gender, :height, :birth_date, :phone, :generic_call_time, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in]
    required_parameters :install_id, :email, :password

    post '/api/v1/signup' do
      let (:install_id)     { "1234" }
      let (:email)          { "tst11@test.com" }
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
      let (:ethnic_group_id)      { 1 }
      let (:diet_id)      { 1 }
      let (:blood_type)      { "B-positive" }
      let (:holds_phone_in)      { "left" }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Sign up using email and password (or add email and password to account)" do
        explanation "If the install ID exists, update that user's account with email and password.  Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns auth_token and the user."
        status.should == 200
        response = JSON.parse(response_body)

        response['auth_token'].should_not be_empty
        response['user'].should_not be_empty
      end
    end

    post '/api/v1/signup' do
      let (:install_id)     { "2222" }
      let (:email)          { "test2@test.com" }
      let (:password)       { "short" }
      let (:raw_post)       { params.to_json }  # JSON format request body

      example_request "[POST] Sign up using email and password (or add email and password to account) (422)" do
        explanation "If the install ID exists, update that user's account with email and password.  Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns auth_token and the user."
        status.should == 422
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'update email address' do
    parameter :auth_token,        "User's auth token"
    parameter :password,          "User's password; for verification"
    parameter :email,             "New email address"
    required_parameters :auth_token, :password, :email

    post '/api/v1/user/update_email' do
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

    post '/api/v1/user/update_email' do
      let (:auth_token)       { @user.auth_token }
      let (:password)         { 'wrong password' }
      let (:raw_post)         { params.to_json }  # JSON format request body

      example_request "[POST] Change the email b (401)" do
        explanation "Returns the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user/update_email' do
      let (:auth_token)       { @user.auth_token }
      let (:password)         { @password }
      let (:email)            { 'email_exists@address.com' }
      let (:raw_post)         { params.to_json }  # JSON format request body

      example_request "[POST] Change the email c (422)" do
        explanation "Returns the user"
        status.should == 422
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'update password' do
    parameter :auth_token,        "User's auth token"
    parameter :current_password,  "User's current password"
    parameter :password,          "New account password"
    required_parameters :auth_token, :current_password, :password

    post '/api/v1/user/update_password' do
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

    post '/api/v1/user/update_password' do
      let (:auth_token)       { @user.auth_token }
      let (:current_password) { 'wrong password' }
      let (:raw_post)         { params.to_json }  # JSON format request body

      example_request "[POST] Change the password b (401)" do
        explanation "Returns the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user/update_password' do
      let (:auth_token)       { @user.auth_token }
      let (:current_password) { "new_password" }
      let (:raw_post)         { params.to_json }  # JSON format request body

      example_request "[POST] Change the password c (412)" do
        explanation "Returns the user"
        puts response_body
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user/update_password' do
      let (:auth_token)       { @user.auth_token }
      let (:current_password) { "new_password" }
      let (:password)         { "short" }
      let (:raw_post)         { params.to_json }  # JSON format request body

      example_request "[POST] Change the password d (422)" do
        explanation "Returns the user"
        status.should == 422
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'update user' do
    parameter :auth_token,    "User's auth token"
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
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :holds_phone_in, "The hand the user holds the phone in (left, right)"
    scope_parameters :user, [:first_name, :last_name, :image_url, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in]
    required_parameters :auth_token

    put '/api/v1/user' do
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
      let (:ethnic_group_id)      { 1 }
      let (:diet_id)      { 1 }
      let (:blood_type)      { "B-positive" }
      let (:holds_phone_in)      { "left" }
      let (:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update user" do
        explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
        status.should == 200
        JSON.parse(response_body)['user'].should_not be_empty
      end
    end

    put '/api/v1/user' do
      let (:auth_token)     { @user.auth_token }
      let (:feature_bucket) { 'invalid value' }
      let (:raw_post)       { params.to_json }  # JSON format request body

      example_request "[PUT] Update user (422)" do
        explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
        status.should == 422
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'update specific user' do
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
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :holds_phone_in, "The hand the user holds the phone in (left, right)"
    scope_parameters :user, [:email, :first_name, :last_name, :image_url, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in]
    required_parameters :auth_token, :id

    put '/api/v1/user/:id' do
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
      let (:ethnic_group_id)      { 1 }
      let (:diet_id)      { 1 }
      let (:blood_type)      { "B-positive" }
      let (:holds_phone_in)      { "left" }
      let (:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update a specific user" do
        explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
        status.should == 200
        JSON.parse(response_body)['user'].should_not be_empty
      end
    end

    put '/api/v1/user/:id' do
      let (:auth_token) { @user.auth_token }
      let (:id)         { 123 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[PUT] Update a specific user b (401)" do
        explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/user/:id' do
      let (:auth_token) { @admin_user.auth_token }
      let (:id)         { 1234 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[PUT] Update a specific user c (404)" do
        explanation "Update attributes for the specified user, if the currently logged in user has permission to do so.  Admin can update any user."
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
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
