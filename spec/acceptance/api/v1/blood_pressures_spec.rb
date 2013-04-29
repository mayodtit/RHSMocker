require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "BloodPressures" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    FactoryGirl.create(:blood_pressure, :user=>@user)
    FactoryGirl.create(:blood_pressure, :user=>@user)
  end


  get 'api/v1/blood_pressures' do
    parameter :auth_token, "User's auth_token"
    required_parameters :auth_token

    let (:auth_token) { @user.auth_token }

    example_request "[GET] Get all user's blood_pressures" do
      explanation "Returns an array of blood_pressures recorded by the user"
      status.should == 200
      JSON.parse(response_body)['blood_pressures'].should be_a Array
    end
  end


  describe 'create user_weight' do
    parameter :auth_token,    "User's auth token"
    parameter :diastolic,     "User's diastolic pressure"
    parameter :systolic,      "User's systolic pressure"
    parameter :pulse,         "User's pulse"
    parameter :collection_type_id,         "collection_type_id optional (will make it 'self-reported' by defaults)"

    required_parameters :auth_token, :diastolic, :systolic


    post '/api/v1/blood_pressures' do
      let (:auth_token) { @user.auth_token }
      let (:diastolic)  { 90 }
      let (:systolic)   { 91 }
      let (:pulse)      { 92 }
      let (:collection_type_id)      { 1 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Set user's blood pressure" do
        explanation "Set the user's blood pressure"
        status.should == 200
        JSON.parse(response_body).should_not be_empty
      end
    end

    post '/api/v1/blood_pressures' do
      let (:auth_token) { @user.auth_token }
      let (:diastolic)  { 90 }
      let (:pulse)      { 92 }
      let (:raw_post)   { params.to_json }  # JSON format request body

      example_request "[POST] Set user's blood pressure b (412)" do
        explanation "Set the user's blood pressure"
        status.should == 412
        JSON.parse(response_body)['reason'].should_not be_empty
      end
    end
  end

end
