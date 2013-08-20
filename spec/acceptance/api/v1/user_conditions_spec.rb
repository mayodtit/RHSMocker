require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserConditions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let(:user_id) { user.id }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  get '/api/v1/users/:user_id/diseases' do
    let!(:user_condition) { create(:user_condition, :user => user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all diseases for a given user" do
      explanation "Returns an array of diseases"
      status.should == 200
      JSON.parse(response_body)['user_conditions'].should be_a Array
    end
  end

  post '/api/v1/users/:user_id/diseases' do
    let!(:user_condition) { build(:user_condition, :user => user) }

    parameter :disease_id, "ID of allergy to add"
    parameter :start_date, "Start date of the disease"
    parameter :end_date, "End date of the disease"
    parameter :being_treated, "Boolean; is the disease being treated?"
    parameter :diagnosed, "Boolean; was the disease diagnosed?"
    parameter :diagnoser_id, "ID of the user that made the diagnosis"
    parameter :diagnosed_date, "ID of the user that made the diagnosis"
    required_parameters :disease_id
    scope_parameters :user_condition, [:disease_id, :start_date, :end_date, :being_treated, :diagnosed,
                                     :diagnoser_id, :diagnosed_date]

    let(:disease_id) { user_condition.disease_id }
    let(:start_date) { user_condition.start_date + 1.day }
    let(:end_date) { user_condition.end_date + 1.day }
    let(:being_treated) { true }
    let(:diagnosed) { true }
    let(:diagnoser_id) { create(:user).id }
    let(:diagnosed_date){ user_condition.start_date + 1.day }
    let(:raw_post) { params.to_json }

    example_request "[POST] Add a disease for a user" do
      explanation "Returns the created user disease object"
      status.should == 200
      JSON.parse(response_body)['user_condition'].should be_a Hash
    end
  end

  put '/api/v1/users/:user_id/diseases/:id' do
    let!(:user_condition) { create(:user_condition, :user => user) }

    parameter :id, "ID of the disease the user has; this is the user disease ID"
    parameter :start_date, "Start date of the disease"
    parameter :end_date, "End date of the disease"
    parameter :being_treated, "Boolean; is the disease being treated?"
    parameter :diagnosed, "Boolean; was the disease diagnosed?"
    parameter :diagnoser_id, "ID of the user that made the diagnosis"
    parameter :diagnosed_date, "ID of the user that made the diagnosis"
    required_parameters :id
    scope_parameters :user_condition, [:id, :start_date, :end_date, :being_treated, :diagnosed, :diagnoser_id,
                                     :diagnosed_date]

    let(:id) { user_condition.id }
    let(:start_date) { user_condition.start_date + 1.day }
    let(:end_date) { user_condition.end_date + 1.day }
    let(:being_treated) { true }
    let(:diagnosed) { true }
    let(:diagnoser_id) { create(:user).id }
    let(:diagnosed_date){ user_condition.start_date + 1.day }
    let(:raw_post) { params.to_json }

    example_request "[PUT] Update the user's disease" do
      explanation "Returns the updated user disease object"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  delete '/api/v1/users/:user_id/diseases/:id' do
    let!(:user_condition) { create(:user_condition, :user => user) }

    parameter :id, "ID of the user's disease to remove"
    required_parameters :id

    let(:id) { user_condition.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Delete a user's disease" do
      explanation "Delete's the specified disease for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
