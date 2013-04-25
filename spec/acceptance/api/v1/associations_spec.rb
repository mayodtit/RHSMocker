require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Associations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @user2 = FactoryGirl.create(:user_with_email)

    associate = FactoryGirl.create(:associate)
    @association = FactoryGirl.create(:association, :user=>@user, :associate=>associate)

    associate2 = FactoryGirl.create(:associate)
    @association2 = FactoryGirl.create(:association, :user=>@user2, :associate=>associate2)

    associate3 = FactoryGirl.create(:associate)
    @association3 = FactoryGirl.create(:association, :user=>@user, :associate=>associate3)
  end


  get '/api/v1/associations' do
    parameter :auth_token,      "User's auth token"
    required_parameters :auth_token

    let(:auth_token)   { @user.auth_token }

    example_request "[GET] Get user's associations" do
      explanation "Returns an array of the user's associations (relationships)"
      status.should == 200
      JSON.parse(response_body)['associations'].should be_a Array
    end
  end


  describe 'create an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the associate parameter"
    parameter :relation,        "The relation of the associate (sister, doctor)"
    parameter :relation_type,   "The type of relation of the associate (family or hcp)"
    parameter :associate,       "Attributes of the associate"

    scope_parameters :association, [:associate, :relation, :relation_type]
    required_parameters :auth_token, :association, :relation, :relation_type


    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:relation)      { "sister" }
      let(:relation_type) { "family" }
      let(:associate)    { nil }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association" do
        explanation "Create an association between the user and the specified associate"
        status.should == 200
        JSON.parse(response_body)['association'].should be_a Hash
      end
    end

    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association b (412)" do
        explanation "Create an association between the user and the specified associate"
        status.should == 412
      end
    end

    post '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:relation)      { "sister" }
      let(:relation_type) { "someone" }
      let(:associate)    { nil }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[POST] Create an association c (412)" do
        explanation "Create an association between the user and the specified associate. Fails because 'someone' is not a valid relation_type"
        status.should == 412
      end
    end
  end


  describe 'update an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the association's attributes"
    parameter :id,              "Association ID"
    parameter :relation,        "The relation of the associate (sister, doctor)"
    parameter :relation_type,   "The type of relation of the associate (family or hcp)"
    
    scope_parameters :association, [:id, :relation, :relation_type]
    required_parameters :auth_token, :association, :id


    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association.id }
      let(:relation)      { "grandmother" }
      let(:relation_type) { "family" }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 200
        JSON.parse(response_body)['association'].should be_a Hash
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { 1234 }
      let(:relation)      { "grandmother" }
      let(:relation_type) { "family" }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association b (404)" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association2.id }
      let(:relation)      { "grandmother" }
      let(:relation_type) { "family" }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association c (401)" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    put '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)            { @association.id }
      let(:relation)      { "not_a_valid_value" }
      let(:relation_type) { "family" }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[PUT] Update an association d (422)" do
        explanation "Update an association between the user and the specified associate (by ID)"
        status.should == 422
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end


  describe 'delete an association' do
    parameter :auth_token,      "User's auth token"
    parameter :association,     "Contains the ID parameter"
    parameter :id,              "Association ID"

    scope_parameters :association, [:id]
    required_parameters :auth_token, :association, :id


    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { @association.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association" do
        explanation "Deletes the specified association"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { 1234 }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association b (404)" do
        explanation "Deletes the specified association"
        status.should == 404
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end

    delete '/api/v1/associations' do
      let(:auth_token)   { @user.auth_token }
      let(:id)           { @association2.id }
      let(:raw_post)     { params.to_json }  # JSON format request body

      example_request "[DELETE] Delete an association c (401)" do
        explanation "Deletes the specified association"
        status.should == 401
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
