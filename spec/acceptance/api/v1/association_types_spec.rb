require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "AssociationTypes" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/association_types' do
    let!(:association_type) { create(:association_type) }

    example_request "[GET] Get all association types" do
      explanation "Returns a hash of association_types by relationship type"
      status.should == 200
      JSON.parse(response_body).should be_a Hash
    end
  end
end
