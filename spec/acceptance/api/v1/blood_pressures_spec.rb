require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'BloodPressures' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:user) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token

  get '/api/v1/users/:user_id/blood_pressures' do
    parameter :user_id, 'User ID for which to get blood pressures'
    required_parameters :user_id

    let(:user_id) { user.id }
    let!(:blood_pressure) { create(:blood_pressure, :user => user) }
    let(:raw_post) { params.to_json }

    example_request "[GET] Get all blood_pressures for a user" do
      explanation 'Returns an array of blood_pressures recorded by the user'
      status.should == 200
      JSON.parse(response_body)['blood_pressures'].should be_a Array
    end
  end

  post '/api/v1/users/:user_id/blood_pressures' do
    parameter :user_id, 'user for which to create a new record'
    parameter :diastolic, "User's diastolic pressure"
    parameter :systolic, "User's systolic pressure"
    parameter :pulse, "User's pulse"
    parameter :taken_at, "DateTime of when the reading was taken"
    parameter :collection_type_id, "collection_type_id optional (will make it 'self-reported' by defaults)"
    required_parameters :user_id, :diastolic, :systolic

    let(:user_id) { user.id }
    let(:diastolic) { 90 }
    let(:systolic) { 91 }
    let(:pulse) { 92 }
    let(:taken_at) { DateTime.now-20.minutes }
    let(:collection_type_id) { 1 }
    let(:raw_post) { params.to_json }

    example_request "[POST] Set user's blood pressure" do
      explanation "Set the user's blood pressure"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

  delete '/api/v1/blood_pressures/:id' do
    parameter :id, "Blood pressure reading id"
    required_parameters :id

    let!(:blood_pressure) { create(:blood_pressure, :user => user) }
    let(:id) { blood_pressure.id }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Remove user's blood pressure reading" do
      explanation "Remove user's blood pressure reading"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
