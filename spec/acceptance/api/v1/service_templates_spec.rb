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
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

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

    post '/api/v1/service_templates' do
      let!(:service_type) { create :service_type}
      let!(:service_template) { build(:service_template, :service_type => service_type) }

      parameter :name, "name of the service template"
      parameter :title, "title of the service template"
      parameter :description, "description of the service template"
      parameter :service_type_id, "Integer; id of the associated service type"
      parameter :time_estimate, "Estimate in minutes for length of service"
      required_parameters :name, :title, :service_type_id
      scope_parameters :service_template, [:name, :title, :description, :service_type_id, :time_estimate]

      let(:name) { service_template.name }
      let(:title) { service_template.title }
      let(:description) { service_template.description }
      let(:service_type_id) { service_type.id }
      let(:time_estimate) { service_template.time_estimate }
      let(:raw_post) { params.to_json }

      example_request "[POST] Create a service_template" do
        explanation "Returns the created user service_template object"
        expect(status).to eq(200)
        JSON.parse(response_body)['service_template'].should be_a Hash
      end
    end
  end
end
