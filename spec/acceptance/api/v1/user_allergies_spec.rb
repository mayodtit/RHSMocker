require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserAllergies" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user) }
  let(:auth_token) { user.auth_token }
  let(:user_id) { user.id }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  get '/api/v1/users/:user_id/allergies' do
    let!(:user_allergy) { create(:user_allergy, :user => user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all allergies for a user" do
      explanation 'Returns an array of allergies for the user'
      status.should == 200
      JSON.parse(response_body)['user_allergies'].should be_a Array
    end
  end

  get '/api/v1/users/:user_id/allergies/:id' do
    let!(:user_allergy) { create(:user_allergy, :user => user) }
    let(:id) { user_allergy.id }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get a given allergy for a user" do
      explanation 'Returns the allergy for the user'
      status.should == 200
      JSON.parse(response_body)['user_allergy'].should be_a Hash
    end
  end

  post '/api/v1/users/:user_id/allergies' do
    let!(:user_allergy) { build(:user_allergy, :user => user) }

    parameter :allergy_id, "ID of allergy to add"
    required_parameters :allergy_id
    scope_parameters :user_allergy, [:allergy_id]

    let(:allergy_id) { user_allergy.allergy_id }
    let(:raw_post) { params.to_json }

    example_request "[POST] Add an allergy for a user" do
      explanation "Return the created user allergy"
      status.should == 200
      JSON.parse(response_body)['user_allergy'].should be_a Hash
    end
  end

  delete '/api/v1/users/:user_id/allergies/:id' do
    parameter :id, "User Allergy ID"
    required_parameters :id

    let!(:user_allergy) { create(:user_allergy, :user => user) }
    let(:id) { user_allergy.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Delete a user's allergy" do
      explanation "Delete's the specified allergy for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
