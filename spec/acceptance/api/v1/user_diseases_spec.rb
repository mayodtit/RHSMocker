require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserDiseases" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login

    @disease = FactoryGirl.create(:disease)
    @user_disease = FactoryGirl.create(:user_disease, :user=>@user, :disease=>@disease)

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

  post '/api/v1/user_diseases' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the disease_id"  
    parameter :disease_id,    "ID of the disease the user has"
    
    required_parameters :auth_token, :user_disease, :disease_id
    scope_parameters :user_disease, [:disease_id]

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
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the disease_id"  
    parameter :disease_id,    "ID of the disease the user has"
    parameter :user_id,    "ID of the associate you want to add a disease to"
    
    required_parameters :auth_token, :user_disease, :disease_id, :user_id
    scope_parameters :user_disease, [:disease_id]

    let(:auth_token)    { @user.auth_token }
    let(:disease_id)    { @disease.id }
    let(:user_id)    { @associate.id }
    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[POST] Add a disease for an associate" do
      explanation "Returns the created user disease object"
      status.should == 200
      JSON.parse(response_body)['user_disease'].should be_a Hash
    end
  end

  put '/api/v1/user_diseases' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the fields to be updated"
    parameter :id,            "ID of the disease the user has; this is the user disease ID"
    parameter :start_date,    "Start date of the disease"
    parameter :end_date,      "End date of the disease"
    parameter :being_treated, "Boolean; is the disease being treated?"
    parameter :diagnosed,     "Boolean; was the disease diagnosed?"
    
    required_parameters :auth_token, :user_disease, :id
    scope_parameters :user_disease, [:id, :start_date, :end_date, :being_treated, :diagnosed]

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

  delete '/api/v1/user_diseases' do
    parameter :auth_token,    "User's auth token"
    parameter :user_disease,  "Contains the ID"  
    parameter :id,            "ID of the user's disease to remove"
    
    required_parameters :auth_token, :user_disease, :id
    scope_parameters :user_disease, [:id]

    let(:auth_token)    { @user.auth_token }
    let(:id)            { @user_disease.id }
    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[DELETE] Delete a user's disease" do
      explanation "Delete's the specified disease for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
