require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserConditions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let(:user_id) { user.id }

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  get '/api/v1/users/:user_id/conditions' do
    let!(:user_condition) { create(:user_condition, :user => user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all conditions for a given user" do
      explanation "Returns an array of conditions"
      status.should == 200
      JSON.parse(response_body)['user_conditions'].should be_a Array
    end
  end

  post '/api/v1/users/:user_id/conditions' do
    let!(:user_condition) { build(:user_condition, :user => user) }

    parameter :condition, "Condition being added"
    parameter :start_date, "Start date of the condition"
    parameter :end_date, "End date of the condition"
    parameter :being_treated, "Boolean; is the condition being treated?"
    parameter :diagnosed, "Boolean; was the condition diagnosed?"
    parameter :diagnoser_id, "ID of the user that made the diagnosis"
    parameter :diagnosed_date, "ID of the user that made the diagnosis"
    parameter :name, "Name of condition"
    parameter :snomed_name, "Official name of condition"
    parameter :concept_id, "Concept ID of condition (not always unique)"
    parameter :description_id, "Description ID of condition (unique)"
    parameter :snomed_code, "Official ID of condition"
    
    required_parameters :condition, :name, :snomed_name, :concept_id, :description_id
    scope_parameters :user_condition, [:condition, :start_date, :end_date, :being_treated, :diagnosed,
                                     :diagnoser_id, :diagnosed_date]
    scope_parameters :condition, [:name, :snomed_code, :snomed_name, :concept_id, :description_id]

    let(:condition) { 
      {
        name: "ADHD - Attention deficit disorder with hyperactivity",
        snomed_code: "406506008",
        snomed_name: "Attention deficit hyperactivity disorder (disorder)",
        concept_id: "406506008",
        description_id: "2163260014"
      }
    }

    let(:start_date) { user_condition.start_date + 1.day }
    let(:end_date) { user_condition.end_date + 1.day }
    let(:being_treated) { true }
    let(:diagnosed) { true }
    let(:diagnoser_id) { create(:user).id }
    let(:diagnosed_date){ user_condition.start_date + 1.day }
    let(:raw_post) { params.to_json }

    example_request "[POST] Add a condition for a user" do
      explanation "Returns the created user condition object"
      status.should == 200
      JSON.parse(response_body)['user_condition'].should be_a Hash
    end
  end

  put '/api/v1/users/:user_id/conditions/:id' do
    let!(:user_condition) { create(:user_condition, :user => user) }

    parameter :id, "ID of the condition the user has; this is the user condition ID"
    parameter :start_date, "Start date of the condition"
    parameter :end_date, "End date of the condition"
    parameter :being_treated, "Boolean; is the condition being treated?"
    parameter :diagnosed, "Boolean; was the condition diagnosed?"
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

    example_request "[PUT] Update the user's condition" do
      explanation "Returns the updated user condition object"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  delete '/api/v1/users/:user_id/conditions/:id' do
    let!(:user_condition) { create(:user_condition, :user => user) }

    parameter :id, "ID of the user's condition to remove"
    required_parameters :id

    let(:id) { user_condition.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Delete a user's condition" do
      explanation "Delete's the specified condition for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
