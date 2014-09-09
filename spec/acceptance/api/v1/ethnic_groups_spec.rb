require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "EthnicGroups" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/ethnic_groups' do
    before do
      create_list(:ethnic_group, 3)
    end

    example_request "[GET] Get all ethnic group" do
      explanation "Returns an array of ethnic groups"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
