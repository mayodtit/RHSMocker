require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserAllergies" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)
    @user2.login

    @allergy = FactoryGirl.create(:allergy, :name=>'pollen')

    allergy = FactoryGirl.create(:allergy)
    @user_allergy = FactoryGirl.create(:user_allergy, :user=>@user, :allergy=>allergy)

    allergy2 = FactoryGirl.create(:allergy)
    @user_allergy2 = FactoryGirl.create(:user_allergy, :user=>@user, :allergy=>allergy2)
  end


  get '/api/v1/user_allergies' do
    parameter :auth_token,    "User's auth token"
    required_parameters :auth_token

    let(:auth_token)  { @user.auth_token }

    example_request "[GET] Get all of this user's allergies" do
      explanation "Returns an array of allergies"
      status.should == 200
      JSON.parse(response_body)['user_allergies'].should be_a Array
    end
  end


  describe 'create allergy' do
    parameter :auth_token,    "User's auth token" 
    parameter :allergy_id,    "Allergy ID"
    required_parameters :auth_token, :allergy_id

    post '/api/v1/user_allergies' do
      let(:auth_token)   { @user.auth_token }
      let(:allergy_id)   { @allergy.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Add an allergy for current user" do
        explanation "Return the created user allergy object"
        status.should == 200
        JSON.parse(response_body)['user_allergy'].should be_a Hash
      end
    end

    post '/api/v1/user_allergies' do
      let(:auth_token)   { @user.auth_token }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Add an allergy for current user b (412)" do
        explanation "Return the created user allergy object"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    post '/api/v1/user_allergies' do
      let(:auth_token)   { @user.auth_token }
      let(:allergy_id)   { 1234 }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Add an allergy for current user c (404)" do
        explanation "Return the created user allergy object"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'remove allergy' do
    parameter :auth_token,        "User's auth token" 
    parameter :user_allergy_id,   "User Allergy ID"
    required_parameters :auth_token, :user_allergy_id

    delete '/api/v1/user_allergies' do
      let(:auth_token)      { @user.auth_token }
      let(:user_allergy_id) { @user_allergy.id }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's allergy" do
        explanation "Delete's the specified allergy for the user"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    delete '/api/v1/user_allergies' do
      let(:auth_token)      { @user.auth_token }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's allergy b (412)" do
        explanation "Delete's the specified allergy for the user"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/user_allergies' do
      let(:auth_token)      { @user.auth_token }
      let(:user_allergy_id) { 1234 }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's allergy c (404)" do
        explanation "Delete's the specified allergy for the user"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/user_allergies' do
      let(:auth_token)      { @user2.auth_token }
      let(:user_allergy_id) { @user_allergy2.id }
      let(:raw_post)        { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete a user's allergy d (401)" do
        explanation "Delete's the specified allergy for the user"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
