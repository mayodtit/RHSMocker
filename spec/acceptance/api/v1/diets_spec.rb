require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Diets" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/diets' do
    before do
      create_list(:diet, 3)
    end

    example_request "[GET] Get all diet options" do
      explanation "Returns an array of diet options"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
