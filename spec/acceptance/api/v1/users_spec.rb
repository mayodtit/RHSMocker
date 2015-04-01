require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:current_password) { 'current_password' }
  let(:user) { create(:member, :trial, password: current_password) }
  let(:session) { user.sessions.create }

  before do
    CarrierWave::Mount::Mounter.any_instance.stub(:store!)
  end

  get '/api/v1/users' do
    parameter :auth_token, "User's Auth token"
    parameter :first_name, "Optional filter for external search"
    parameter :last_name, "Optional filter for external search"
    parameter :state, "Optional filter for external search"
    parameter :city_name, "Optional filter for external search"
    parameter :zip, "Optional filter for external search"
    required_parameters :auth_token

    let(:auth_token) { session.auth_token }
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

  context 'create normal user' do
    describe 'create user with email and password' do
      parameter :install_id, "Unique install ID"
      parameter :email, "Account email"
      parameter :password, "Account password"
      parameter :token, "Invitation token"
      scope_parameters :user, [:install_id, :email, :password, :token]
      required_parameters :install_id, :email, :password, :token

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
          response[:auth_token].should == new_user.sessions.first.auth_token
        end
      end
    end
  end

  context 'create business on boarding user' do
    describe 'create user with email and password' do
      parameter :email, "Account email"
      parameter :password, "Account password"
      parameter :business_on_board, "yes"
      scope_parameters :user, [:email, :password, :business_on_board]
      required_parameters :email, :password

      post '/api/v1/signup' do
        let(:install_id) { "1234" }
        let(:email) { "tst11@test.com" }
        let(:password) { "11111111" }
        let(:business_on_board) {"yes"}
        let(:raw_post) { params.to_json }

        example_request "[POST] Sign up using email and password and send inviation email" do
          explanation "Generate invite and confirmation emmail email and send to user with login link."
          status.should == 200
          expect(Member.last.email).to eq(email)
          expect(Delayed::Job.count).to eq(2)
        end
      end
    end
  end

  put '/api/v1/users/:id/secure_update' do
    parameter :auth_token, "User's auth token"
    parameter :current_password, "User's current password"
    parameter :email, 'New email for the current user'
    parameter :password, 'New password for the current user'
    scope_parameters :user, [:current_password, :email, :password]
    required_parameters :auth_token, :current_password

    let(:id) { user.id }
    let(:auth_token) { session.auth_token }
    let(:email) { 'new_email@test.com' }
    let(:password) { 'new_password' }
    let(:raw_post) { params.to_json }

    example_request "[PUT] Update the current_user's secure attributes" do
      explanation "Updates the current_user's email or password"
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:user].to_json).to eq(user.reload.serializer.as_json.to_json)
      expect(user.email).to eq(email)
    end
  end

  describe 'update user' do
    parameter :auth_token, "User's auth token"
    parameter :first_name, "User's first name"
    parameter :last_name, "User's last name"
    parameter :avatar, 'Base64 encoded image'
    parameter :gender, "User's gender(male or female)"
    parameter :height, "User's height(in cm)"
    parameter :birth_date, "User's birth date"
    parameter :phone, "User's phone number"
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :deceased, "Boolean, is the user deceased"
    parameter :date_of_death, "If the user is deceased, when did they die"
    scope_parameters :user, [:first_name, :last_name, :avatar, :gender, :height, :birth_date, :phone, :ethnic_group_id, :diet_id, :blood_type, :deceased, :date_of_death]
    required_parameters :auth_token

    put '/api/v1/user' do
      let(:first_name) { "Bob" }
      let(:last_name) { "Smith" }
      let(:gender) { "male" }
      let(:height) { 190 }
      let(:birth_date) { "1980-10-15" }
      let(:phone) { "4163442356" }
      let(:auth_token) { session.auth_token }
      let(:ethnic_group_id) { 1 }
      let(:diet_id) { 1 }
      let(:blood_type) { "B-positive" }
      let(:deceased) { false }
      let(:raw_post) { params.to_json }
      let(:avatar) { base64_test_image }

      example_request "[PUT] Update user" do
        explanation "Update attributes for currently logged in user (as identified by auth_token). Can pass additional user fields, such as first_name, gender, birth_date, etc.  Returns the updated user"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)[:user]
        response.to_json.should == user.reload.serializer.as_json.to_json
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
    parameter :first_name, "User's first name"
    parameter :last_name, "User's last name"
    parameter :avatar, 'Base64 encoded image'
    parameter :gender, "User's gender(male or female)"
    parameter :height, "User's height(in cm)"
    parameter :birth_date, "User's birth date"
    parameter :phone, "User's phone number"
    parameter :ethnic_group_id, "User's ethnic group"
    parameter :diet_id, "User's diet id"
    parameter :blood_type, "User's blood type"
    parameter :deceased, "Boolean, is the user deceased"
    parameter :date_of_death, "If the user is deceased, when did they die"
    parameter :provider_taxonomy_code, "Associate's healthcare provider taxonomy code"
    parameter :status_event, 'Change member status; available only to admin; one of ["upgrade", "downgrade", "grant_free_trial", "chamathify"]'
    scope_parameters :user, [:email, :first_name, :last_name, :avatar, :gender,
                             :height, :birth_date, :phone, :ethnic_group_id,
                             :diet_id, :blood_type, :deceased,
                             :date_of_death, :provider_taxonomy_code, :status_event]
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
      let(:auth_token) { session.auth_token }
      let(:ethnic_group_id) { 1 }
      let(:diet_id) { 1 }
      let(:blood_type) { "B-positive" }
      let(:deceased) { false }
      let(:provider_taxonomy_code) { 'abcde' }
      let(:raw_post) { params.to_json }
      # purposely don't include avatar

      example_request "[PUT] Update a specific user" do
        explanation "Update attributes for the specified user, if the currently logged in user has permission to do so"
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)[:user]
        response.to_json.should == associate.reload.serializer.as_json.to_json
        response.keys.should include(:avatar_url)
        response[:avatar_url].should be_nil # check for non_nil avatar in 'update user' spec
      end
    end
  end

  describe 'get current user' do
    parameter :auth_token, 'User\'s auth token'
    required_parameters :auth_token

    let(:auth_token) { session.auth_token }

    get '/api/v1/user' do
      example_request '[GET] Get the current user' do
        explanation 'Get the current user\'s info'
        status.should == 200
        response = JSON.parse(response_body, :symbolize_names => true)
        response[:user].to_json.should == user.serializer(include_roles: true).as_json.to_json
      end
    end
  end
end
