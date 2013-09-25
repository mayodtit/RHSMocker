require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:current_password) { 'current_password' }
  let(:user) { create(:user_with_email, :password => current_password,
                                        :password_confirmation => current_password).tap{|u| u.login} }

  get '/api/v1/users' do
    parameter :auth_token, "User's Auth token"
    parameter :first_name, "Optional filter for external search"
    parameter :last_name, "Optional filter for external search"
    parameter :state, "Optional filter for external search"
    parameter :city_name, "Optional filter for external search"
    parameter :zip, "Optional filter for external search"
    required_parameters :auth_token

    let(:auth_token) { user.auth_token }
    let(:last_name) { 'chilcutt' }

    before(:each) do
      Search::Service.any_instance.stub(:query => [ {:first_name => 'Kyle',
                                                     :last_name => 'Chilcutt',
                                                     :npi_number => '0123456789',
                                                     :city => 'San Francisco',
                                                     :state => 'CA',
                                                     :expertise => 'Counterfeiting Medical Credentials'} ])
    end

    example_request "[GET] Get list of users from external source (e.g. NPI database)" do
        explanation "Returns an array of Users that match the parameters"
        status.should == 200
        JSON.parse(response_body)['users'].should be_a Array
    end
  end

  get '/api/v1/users/:id/keywords' do
    let!(:user_reading) { create(:user_reading, :user => user) }

    parameter :auth_token, "User's Auth token"
    parameter :id, "user's ID"
    required_parameters :auth_token, :id

    let(:auth_token) { user.auth_token }
    let(:id) { user.id }
    let(:raw_post) { params.to_json }

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
      let(:install_id) { "1234" }
      let(:raw_post) { params.to_json }

      example_request "[DEPRECATED] [POST] Sign up using install ID" do
        explanation "Returns auth_token and the user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        new_user = User.find(response[:user][:id])
        response[:auth_token].should == new_user.auth_token
        response[:user].to_json.should == new_user.as_json.to_json
      end
    end
  end

  describe 'create user with email and password' do
    parameter :install_id, "Unique install ID"
    parameter :email, "Account email"
    parameter :password, "Account password"
    scope_parameters :user, [:install_id, :email, :password]
    required_parameters :install_id, :email, :password

    post '/api/v1/signup' do
      let(:install_id) { "1234" }
      let(:email) { "tst11@test.com" }
      let(:password) { "11111111" }
      let(:raw_post) { params.to_json }

      example_request "[POST] Sign up using email and password (or add email and password to account)" do
        explanation "If the install ID exists, update that user's account with email and password.  Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns auth_token and the user."
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        new_user = User.find(response[:user][:id])
        response[:auth_token].should == new_user.auth_token
        response[:user].to_json.should == new_user.as_json.to_json
      end
    end
  end

  describe 'update email address' do
    parameter :auth_token, "User's auth token"
    parameter :password, "User's password; for verification"
    parameter :email, "New email address"
    required_parameters :auth_token, :password, :email

    post '/api/v1/user/update_email' do
      let(:auth_token) { user.auth_token }
      let(:password) { current_password }
      let(:email) { 'new_email@address.com' }
      let(:raw_post) { params.to_json }

      example_request "[POST] Change the email" do
        explanation "Returns the user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        user.reload.email.should == email
        response[:user].to_json.should == user.as_json.to_json
      end
    end
  end

  describe 'update password' do
    parameter :auth_token, "User's auth token"
    parameter :current_password, "User's current password"
    parameter :password, "New account password"
    required_parameters :auth_token, :current_password, :password

    post '/api/v1/user/update_password' do
      let(:auth_token) { user.auth_token }
      let(:password) { "new_password" }
      let(:raw_post) { params.to_json }

      example_request "[POST] Change the password" do
        explanation "Returns the user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        response[:user].to_json.should == user.reload.as_json.to_json
      end
    end
  end

  describe 'update user' do
    parameter :auth_token, "User's auth token"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"
    parameter :first_name, "User's first name"
    parameter :last_name, "User's last name"
    parameter :avatar, 'Base64 encoded image'
    parameter :gender, "User's gender(male or female)"
    parameter :height, "User's height(in cm)"
    parameter :birth_date, "User's birth date"
    parameter :phone, "User's phone number"
    parameter :generic_call_time, "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket, "User's feature bucket (none message_only call_only message_call)"
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :holds_phone_in, "The hand the user holds the phone in (left, right)"
    parameter :deceased, "Boolean, is the user deceased"
    parameter :date_of_death, "If the user is deceased, when did they die"
    scope_parameters :user, [:first_name, :last_name, :avatar, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in, :deceased, :date_of_death]
    required_parameters :auth_token

    put '/api/v1/user' do
      let(:first_name) { "Bob" }
      let(:last_name) { "Smith" }
      let(:gender) { "male" }
      let(:height) { 190 }
      let(:birth_date) { "1980-10-15" }
      let(:phone) { "4163442356" }
      let(:generic_call_time) { "morning" }
      let(:feature_bucket) { "none" }
      let(:auth_token) { user.auth_token }
      let(:ethnic_group_id) { 1 }
      let(:diet_id) { 1 }
      let(:blood_type) { "B-positive" }
      let(:holds_phone_in) { "left" }
      let(:deceased) { false }
      let(:raw_post) { params.to_json }
      let(:avatar) { base64_test_image }

      example_request "[PUT] Update user" do
        explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)[:user]
        response.to_json.should == user.reload.as_json.to_json
        response[:avatar_url].should_not be_nil # check for nil avatar in 'update specific user' spec
      end
    end
  end


  describe 'update specific user' do
    let!(:association) { create(:association, :user => user) }
    let(:associate) { association.associate }

    parameter :auth_token, "User's auth token"
    parameter :id, "ID of user to update"
    parameter :email, "Account email"
    parameter :feature_bucket, "The feature bucket that the user is in (none, message_only, call_only, message_call)"
    parameter :first_name, "User's first name"
    parameter :last_name, "User's last name"
    parameter :avatar, 'Base64 encoded image'
    parameter :gender, "User's gender(male or female)"
    parameter :height, "User's height(in cm)"
    parameter :birth_date, "User's birth date"
    parameter :phone, "User's phone number"
    parameter :generic_call_time, "User's preferred call time (morning, afternoon, evening)"
    parameter :feature_bucket, "User's feature bucket (none message_only call_only message_call)"
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :holds_phone_in, "The hand the user holds the phone in (left, right)"
    parameter :deceased, "Boolean, is the user deceased"
    parameter :date_of_death, "If the user is deceased, when did they die"
    scope_parameters :user, [:email, :first_name, :last_name, :avatar, :gender, :height, :birth_date, :phone, :generic_call_time, :feature_bucket, :ethnic_group_id, :diet_id, :blood_type, :holds_phone_in, :deceased, :date_of_death]
    required_parameters :auth_token, :id

    put '/api/v1/user/:id' do
      let(:id) { associate.id }
      let(:email) { "tst121@test.com" }
      let(:first_name) { "Bob" }
      let(:last_name) { "Smith" }
      let(:gender) { "male" }
      let(:height) { 190 }
      let(:birth_date) { "1980-10-15" }
      let(:phone) { "4163442356" }
      let(:auth_token) { user.auth_token }
      let(:ethnic_group_id) { 1 }
      let(:diet_id) { 1 }
      let(:blood_type) { "B-positive" }
      let(:deceased) { false }
      let(:raw_post) { params.to_json }
      # purposely don't include avatar

      example_request "[PUT] Update a specific user" do
        explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        response[:user].to_json.should == associate.reload.as_json.to_json
        response[:avatar_url].should be_nil # check for non_nil avatar in 'update user' spec
      end
    end
  end

  describe 'reset password' do
    parameter :email, "User's email address"
    required_parameters :email

    let(:email) { user.email }
    let(:raw_post) { params.to_json }

    post '/api/v1/users/reset_password' do
      example_request "[POST] Reset password (forgot password)" do
        explanation "Emails password reset instructions to the user"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end
  end
end
