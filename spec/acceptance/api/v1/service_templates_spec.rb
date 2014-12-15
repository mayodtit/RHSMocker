require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ServiceTemplates" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:service_template) { create(:service_template) }
  let!(:another_service_template) { create(:service_template) }
  let(:auth_token) { session.auth_token }

  describe 'service_template' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Service id'

    required_parameters :auth_token, :id

    let(:auth_token) { session.auth_token }
    let(:id) { service_template.id }

    get '/api/v1/service_templates' do
      example_request '[GET] Get all service_templates' do
        explanation 'Get all service templates'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:service_templates].to_json.should == [service_template, another_service_template].serializer.to_json
      end
    end

    get '/api/v1/service_templates/:id' do
      example_request '[GET] Get a service_template' do
        explanation 'Get a service_template (along with the member\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:service_template].to_json.should == service_template.serializer.to_json
      end
    end
  end
end
