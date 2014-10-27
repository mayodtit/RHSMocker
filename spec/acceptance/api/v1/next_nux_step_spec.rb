require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'NextNuxStep' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/next_nux_step' do
    example_request '[GET] Get next NUX step' do
      explanation 'Get next NUX step'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:nux][:next]).to eq('credit_card')
    end
  end
end
