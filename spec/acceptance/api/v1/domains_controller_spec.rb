require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Domains' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/domains' do  
    parameter :email, "email being checked"
    required_parameters :email
    let!(:domain) { create(:domain, email_domain: 'gmail.com') }
    let(:email) { 'michael@gmai.com' }
    let(:suggestion) {
                      {
                        address: 'michael',
                        domain: 'gmail.com',
                        full: 'michael@gmail.com'
                      }
                    }
    
    example_request '[GET] Email correction suggestions (if any)' do
      explanation 'Returns a suggestion if one is found, returns 422 response if domain is invalid'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:suggestion].to_json).to eq(suggestion.as_json.to_json)
    end
  end

  get '/api/v1/domains/all_domains' do
    example_request '[GET] All email domains stored on the server' do
      explanation 'Return an array of domains stored'
      expect(status).to eq(200)
      JSON.parse(response_body).should_not be_empty
    end
  end

  get '/api/v1/domains/suggest' do
    parameter :email, "email being checked"
    required_parameters :email
    let!(:domain) { create(:domain, email_domain: 'gmail.com') }
    let(:email) { 'michael@g' }

    example_request '[GET] Email auto complete suggestions' do
      explanation 'Returns an array of autocomplete suggestions'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:domains].to_json).to eq("[\"gmail.com\"]")
    end
  end
end
