require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserDiseaseTreatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    @hcp = FactoryGirl.create(:hcp_user)

    @disease = FactoryGirl.create(:disease)
    @user_disease = FactoryGirl.create(:user_disease, :user=>@user, :disease=>@disease)
    @disease2 = FactoryGirl.create(:disease)
    @user_disease2 = FactoryGirl.create(:user_disease, :user=>@user, :disease=>@disease2)

    treatment = FactoryGirl.create(:treatment)
    @user_disease_treatment = FactoryGirl.create(:user_disease_treatment, :user=>@user, :treatment=>treatment, :user_disease=>@user_disease, :doctor_user_id=>@hcp.id)
    
    @treatment = FactoryGirl.create(:treatment)
  end


  get '/api/v1/user_disease_treatments' do
    parameter :auth_token,       "User's auth token"
    required_parameters :auth_token

    let(:auth_token)    { @user.auth_token }

    example_request "[GET] Get all of this user's treatments" do
      explanation "Returns an array of treatments for the specified user"
      status.should == 200
      JSON.parse(response_body)['user_disease_treatments'].should be_a Array
    end
  end

  post '/api/v1/user_disease_treatments' do
    parameter :auth_token,              "User's auth token"
    parameter :user_disease_treatment,  "A hash; Contains treatment properties"
    parameter :treatment_id,            "ID of the treatment the user is using"
    parameter :user_disease_id,         "ID of the user disease this treatment is for"
    parameter :prescribed_by_doctor,    "Boolean; is the treatment prescribed by a HCP"
    parameter :doctor_user_id,          "ID of HCP that prescribed the treatment"
    parameter :start_date,              "Start date of this treatment"
    parameter :end_date,                "End date of this treatment"
    parameter :time_duration,           "Integer; frequency of treatment - how often"
    parameter :time_duration_unit,      "Unit for time_duration; i.e. day(s), hour(s)"
    parameter :amount,                  "Integer; frequency of treatment - how many"
    parameter :amount_unit,             "Unit for amount; i.e. pill(s), tsp, mL"
    parameter :side_effect,             "Boolean; does this treatment have a side effect?"
    parameter :successful,              "Boolean; was the treatment successful?"

    required_parameters :auth_token, :user_disease_treatment, :treatment_id, :prescribed_by_doctor,
      :start_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect
    scope_parameters :user_disease_treatment, [:treatment_id, :user_disease_id, :prescribed_by_doctor, :doctor_user_id,
      :start_date, :end_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect, :successful]

    let(:auth_token)    { @user.auth_token }
    let(:treatment_id)  { @treatment.id }
    let(:prescribed_by_doctor) { true }
    let(:doctor_user_id) { @hcp.id }
    let(:start_date)    { Date.today }
    let(:time_duration) { 1 }
    let(:time_duration_unit)  { 'day(s)' }
    let(:amount)        { 4 }
    let(:amount_unit)   { 'tsp' }
    let(:side_effect)   { true }
    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[POST] Add a treatment for a user" do
      explanation "Returns the created user disease treatment object"
      status.should == 200
      JSON.parse(response_body)['user_disease_treatment'].should be_a Hash
    end
  end

  put '/api/v1/user_disease_treatments' do
    parameter :auth_token,              "User's auth token"
    parameter :user_disease_treatment,  "Contains the fields to be updated"
    parameter :id,                      "ID of the treatment the user is using"
    parameter :user_disease_id,         "ID of the user disease this treatment is for"
    parameter :prescribed_by_doctor,    "Boolean; is the treatment prescribed by a HCP"
    parameter :doctor_user_id,          "ID of HCP that prescribed the treatment"
    parameter :start_date,              "Start date of this treatment"
    parameter :end_date,                "End date of this treatment"
    parameter :time_duration,           "Integer; frequency of treatment - how often"
    parameter :time_duration_unit,      "Unit for time_duration; i.e. day(s), hour(s)"
    parameter :amount,                  "Integer; frequency of treatment - how many"
    parameter :amount_unit,             "Unit for amount; i.e. pill(s), tsp, mL"
    parameter :side_effect,             "Boolean; does this treatment have a side effect?"
    parameter :successful,              "Boolean; was the treatment successful?"
    
    required_parameters :auth_token, :user_disease_treatment, :id
    scope_parameters :user_disease_treatment, [:id, :user_disease_id, :prescribed_by_doctor, :doctor_user_id,
      :start_date, :end_date, :time_duration, :time_duration_unit, :amount, :amount_unit, :side_effect, :successful]

    let(:auth_token)  { @user.auth_token }
    let(:id)          { @user_disease_treatment.id }
    let(:user_disease_id) { @user_disease2.id }
    let(:end_date)    { Date.tomorrow }
    let(:successful)  { true }
    let(:raw_post)    { params.to_json }  # JSON format request body

    example_request "[PUT] Update the user's treatment" do
      explanation "A HCP can update anyone's treatment; Returns the updated user disease treatment object"
      status.should == 200
      JSON.parse(response_body)['user_disease_treatment'].should be_a Hash
    end
  end

  delete '/api/v1/user_disease_treatments' do
    parameter :auth_token,              "User's auth token"
    parameter :user_disease_treatment,  "Contains the ID"  
    parameter :id,                      "ID of the user_disease_treatment to remove"
    
    required_parameters :auth_token, :user_disease_treatment, :id
    scope_parameters :user_disease_treatment, [:id]

    let(:auth_token)    { @user.auth_token }
    let(:id)            { @user_disease_treatment.id }
    let(:raw_post)      { params.to_json }  # JSON format request body

    example_request "[DELETE] Delete a user_disease_treatment" do
      explanation "A HCP can remove anyone's treatment; Delete's the specified treatment for the user"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
