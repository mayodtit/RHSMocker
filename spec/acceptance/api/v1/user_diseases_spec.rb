require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserDiseases" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)
    @user2.login

    @disease = FactoryGirl.create(:disease)
    @treatment = FactoryGirl.create(:treatment)
    @user_disease = FactoryGirl.create(:user_disease, :user=>@user, :disease=>@disease)
    @user_disease_treatment = FactoryGirl.create(:user_disease_treatment, :user_disease=>@user_disease, :treatment=>@treatment)

    @user_disease2 = FactoryGirl.create(:user_disease, :user=>@user2, :disease=>@disease)

    @associate = FactoryGirl.create(:associate)
    @association = FactoryGirl.create(:association, :user=>@user, :associate=>@associate)
  end


  get '/api/v1/user_diseases' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let(:auth_token)    { @user.auth_token }

    example_request "[GET] Get all of this user's diseases" do
      explanation "Returns an array of diseases"
      status.should == 200
      JSON.parse(response_body)['user_diseases'].should be_a Array
    end
  end


  describe 'create user_disease' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the disease_id"  
    parameter :disease_id,    "ID of the disease the user has"
    
    required_parameters :auth_token, :user_disease, :disease_id
    scope_parameters :user_disease, [:disease_id]

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:disease_id)    { @disease.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for current user" do
        explanation "Returns the created user disease object"
        status.should == 200
        JSON.parse(response_body)['user_disease'].should be_a Hash
      end
    end

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for current user b (412)" do
        explanation "Returns the created user disease object"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:disease_id)    { 1234 }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for current user c (404)" do
        explanation "Returns the created user disease object"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'create user_disease for an associate' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the disease_id"  
    parameter :disease_id,    "ID of the disease the user has"
    parameter :user_id,    "ID of the associate you want to add a disease to"
    
    required_parameters :auth_token, :user_disease, :disease_id, :user_id
    scope_parameters :user_disease, [:disease_id]

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:disease_id)    { @disease.id }
      let(:user_id)       { @associate.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for an associate" do
        explanation "Returns the created user disease object"
        status.should == 200
        JSON.parse(response_body)['user_disease'].should be_a Hash
      end
    end

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:disease_id)    { @disease.id }
      let(:user_id)       { 1234 }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for an associate b (404)" do
        explanation "Returns the created user disease object"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user_diseases' do
      let(:auth_token)    { @user2.auth_token }
      let(:disease_id)    { @disease.id }
      let(:user_id)       { @associate.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[POST] Add a disease for an associate c (401)" do
        explanation "Returns the created user disease object"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'update user_disease' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the fields to be updated"
    parameter :id,            "ID of the disease the user has; this is the user disease ID"
    parameter :start_date,    "Start date of the disease"
    parameter :end_date,      "End date of the disease"
    parameter :being_treated, "Boolean; is the disease being treated?"
    parameter :diagnosed,     "Boolean; was the disease diagnosed?"
    
    required_parameters :auth_token, :user_disease, :id
    scope_parameters :user_disease, [:id, :start_date, :end_date, :being_treated, :diagnosed]

    put '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:id)            { @user_disease.id }
      let(:start_date)    { @user_disease.start_date + 1.day }
      let(:end_date)      { @user_disease.end_date + 1.day }
      let(:being_treated) { true }
      let(:diagnosed)     { true }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update the user's disease" do
        explanation "Returns the updated user disease object"
        status.should == 200
        JSON.parse(response_body)['user_disease'].should be_a Hash
      end
    end

    put '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update the user's disease b (412)" do
        explanation "Returns the updated user disease object"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:id)             { 1234 }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update the user's disease c (404)" do
        explanation "Returns the updated user disease object"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/user_diseases' do
      let(:auth_token)    { @user2.auth_token }
      let(:id)            { @user_disease.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[PUT] Update the user's disease d (401)" do
        explanation "Returns the updated user disease object"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'remove user_disease' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the ID"  
    parameter :id,            "ID of the user's disease to remove"
    
    required_parameters :auth_token, :user_disease, :id
    scope_parameters :user_disease, [:id]

    delete '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:id)            { @user_disease.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's disease" do
        explanation "Delete's the specified disease for the user"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    delete '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's disease b (412)" do
        explanation "Delete's the specified disease for the user"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:id)            { 1234 }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's disease c (404)" do
        explanation "Delete's the specified disease for the user"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/user_diseases' do
      let(:auth_token)    { @user.auth_token }
      let(:id)            { @user_disease2.id }
      let(:raw_post)      { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's disease d (401)" do
        explanation "Delete's the specified disease for the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
