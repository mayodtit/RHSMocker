require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Locations" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  post '/api/v1/locations' do
    parameter :location, "Hash of location attributes"
    parameter :latitude, "User's latitude"
    parameter :longitude, "User's longitude"
    required_parameters :latitude, :longitude

    let(:location) { attributes_for(:location) }
    let(:raw_post) { params.to_json }

    example_request "[POST] Record user's location" do
      explanation "Records the location for the current user"
      status.should == 200
      JSON.parse(response_body)
    end
  end
end
