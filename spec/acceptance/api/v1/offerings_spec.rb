require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Offerings' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:offering) { create(:offering) }
  let(:id) { offering.id }

  get '/api/v1/offering' do
    example_request '[GET] Retreive all available offerings' do
      explanation 'Returns an array of addable offerings'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end

  get '/api/v1/offerings/:id' do
    example_request '[GET] Retreive details for a single offering' do
      explanation 'Returns an array of addable offerings'
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
    end
  end
end
