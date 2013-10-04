require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Ping" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/ping' do
    example_request "[GET] Ping the backend" do
      explanation "Get metadata for the client"
      status.should == 200
    end
  end
end
