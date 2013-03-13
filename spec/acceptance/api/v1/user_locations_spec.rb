require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserLocations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:each) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
  end

  post '/api/v1/location' do
    parameter :auth_token,    "User's auth token"
    parameter :longitude,     "User's longitude"
    parameter :latitude,      "User's latitude"

    required_parameters :auth_token, :longitude, :latitude

    let (:auth_token) { @user.auth_token }
    let (:longitude)  { 0 }
    let (:latitude)   { 0 }
    let (:raw_post)   { params.to_json }  # JSON format request body

    example_request "Set user's location" do
      explanation "Set the current user's location by coordinates"
      status.should == 200
      JSON.parse(response_body)
    end
  end

end
