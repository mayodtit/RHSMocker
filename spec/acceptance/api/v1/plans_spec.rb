require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Plans' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:plan) { create(:plan, :with_offering) }
  let(:id) { plan.id }

  get '/api/v1/plans' do
    example_request '[GET] Retreive all available plans' do
      explanation 'Returns an array of addable plans'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end

  get '/api/v1/plans/:id' do
    example_request '[GET] Retreive details for a single plan' do
      explanation 'Returns an array of addable plans'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end
end
