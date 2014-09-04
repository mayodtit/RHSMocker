require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserDiseaseTreatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let(:user_id) { user.id }

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  get '/api/v1/users/:user_id/treatments' do
    let!(:user_disease_treatment) { create(:user_disease_treatment, :user => user) }
    let(:raw_post) { params.to_json }

    example_request "[DEPRECATED] [GET] Get all treatments for a user" do
      explanation 'Returns an array of treatments for the user'
      status.should == 200
      JSON.parse(response_body)['user_disease_treatments'].should be_a Array
    end
  end

  post '/api/v1/users/:user_id/treatments' do
    let!(:user_disease_treatment) { build(:user_disease_treatment, :user => user) }

    parameter :user_disease_treatment, "A hash; Contains treatment properties"
    parameter :treatment_id, "ID of the treatment the user is using"
    parameter :prescribed_by_doctor, "Boolean; is the treatment prescribed by a HCP"
    parameter :doctor_id, "ID of HCP that prescribed the treatment, required if prescribed_by_doctor is set"
    parameter :start_date, "Start date of this treatment"
    parameter :end_date, "End date of this treatment"
    parameter :time_duration, "Integer; frequency of treatment - how often"
    parameter :time_duration_unit, "Unit for time_duration; i.e. day(s), hour(s)"
    parameter :amount, "Integer; frequency of treatment - how many"
    parameter :amount_unit, "Unit for amount; i.e. pill(s), tsp, mL"
    parameter :side_effect, "Boolean; does this treatment have a side effect?"
    parameter :successful, "Boolean; was the treatment successful?"

    required_parameters :auth_token, :user_disease_treatment, :treatment_id, :prescribed_by_doctor,
      :start_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect
    scope_parameters :user_disease_treatment, [:treatment_id, :prescribed_by_doctor, :doctor_id,
      :start_date, :end_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect, :successful]

    let(:treatment_id) { user_disease_treatment.treatment_id }
    let(:prescribed_by_doctor) { false }
    let(:doctor_id) { nil }
    let(:start_date) { Date.today }
    let(:time_duration) { 1 }
    let(:time_duration_unit)  { 'day(s)' }
    let(:amount) { 4 }
    let(:amount_unit) { 'tsp' }
    let(:side_effect) { false }
    let(:raw_post) { params.to_json }

    example_request "[DEPRECATED] [POST] Add a treatment for a user" do
      explanation "Returns the created user disease treatment object"
      status.should == 200
      JSON.parse(response_body)['user_disease_treatment'].should be_a Hash
    end
  end

  put '/api/v1/users/:user_id/treatments/:id' do
    let!(:user_disease_treatment) { create(:user_disease_treatment, :user => user) }

    parameter :user_disease_treatment,  "Contains the fields to be updated"
    parameter :id,                      "ID of the treatment the user is using"
    parameter :prescribed_by_doctor,    "Boolean; is the treatment prescribed by a HCP"
    parameter :doctor_id,          "ID of HCP that prescribed the treatment"
    parameter :start_date,              "Start date of this treatment"
    parameter :end_date,                "End date of this treatment"
    parameter :time_duration,           "Integer; frequency of treatment - how often"
    parameter :time_duration_unit,      "Unit for time_duration; i.e. day(s), hour(s)"
    parameter :amount,                  "Integer; frequency of treatment - how many"
    parameter :amount_unit,             "Unit for amount; i.e. pill(s), tsp, mL"
    parameter :side_effect,             "Boolean; does this treatment have a side effect?"
    parameter :successful,              "Boolean; was the treatment successful?"
    parameter :side_effects_attributes, "Hash of side effect ids that the user is experiencing"

    required_parameters :id
    scope_parameters :user_disease_treatment, [:prescribed_by_doctor, :doctor_id,
      :start_date, :end_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect, :successful, :side_effects_attributes]

    let(:id)          { user_disease_treatment.id }
    let(:end_date)    { Date.tomorrow }
    let(:successful)  { true }
    let(:raw_post)    { params.to_json }  # JSON format request body

    example_request "[DEPRECATED] [PUT] Update the user's treatment" do
      explanation "A HCP can update anyone's treatment; Returns the updated user disease treatment object"
      status.should == 200
    end
  end

  delete '/api/v1/users/:user_id/treatments/:id' do
    let!(:user_disease_treatment) { create(:user_disease_treatment, :user => user) }

    parameter :id, "ID of the user_disease_treatment to remove"
    required_parameters :id

    let(:id)            { user_disease_treatment.id }
    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[DEPRECATED] [DELETE] Delete a user_disease_treatment" do
      explanation "A HCP can remove anyone's treatment; Delete's the specified treatment for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
