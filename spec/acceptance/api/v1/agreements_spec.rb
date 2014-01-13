require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Agreements' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:agreement) { create(:agreement, :active) }

  get '/api/v1/agreements' do
    example_request '[GET] Get all active Agreements' do
      explanation 'Returns an array of Agreements'
      expect(status).to eq(200)
      body = JSON.parse(response_body, :symbolize_names => true)
      expect(body[:agreements].to_json).to eq([agreement].as_json.to_json)
    end
  end
end
