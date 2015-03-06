require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'ValidateEmail' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  parameter :email, "email being checked"
  required_parameters :email
  
  let(:suggestion) {
                    {
                      address: 'michael',
                      domain: 'gmail.com',
                      full: 'michael@gmail.com'
                    }
                  }
  get '/api/v1/validate_email' do
    example_request '[GET] Email correction suggestions (if any)' do
      explanation 'Returns a suggestion if one is found'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:suggestion].to_json).to eq([suggestion].as_json.to_json)
    end
  end
end
