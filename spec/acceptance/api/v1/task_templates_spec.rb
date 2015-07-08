require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "TaskTemplates" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:service_admin) { create(:service_admin) }
  let(:session) { service_admin.sessions.create }
  let!(:task_template) { create(:task_template) }
  let!(:another_task_template) { create(:task_template) }
  let(:auth_token) { session.auth_token }

  describe 'task_template' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Service id'

    required_parameters :auth_token, :id

    let(:auth_token) { session.auth_token }
    let(:id) { task_template.id }

    get '/api/v1/task_templates' do
      example_request '[GET] Get all task_templates' do
        explanation 'Get all task templates'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task_templates].to_json.should == [task_template, another_task_template].serializer.to_json
      end
    end

    get '/api/v1/task_templates/:id' do
      example_request '[GET] Get a task_template' do
        explanation 'Get a task_template (along with the member\'s information). Accessible only by Service Admins.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task_template].to_json.should == task_template.serializer.to_json
      end
    end

    post '/api/v1/task_templates' do
      let!(:task_template) { build_stubbed(:task_template) }
      parameter :auth_token, 'Service Admin\'s auth_token'
      parameter :name, "name of the task template"
      parameter :title, "title of the task template"
      parameter :description, "description of the task template"
      parameter :time_estimate, "Estimate in minutes for length of service"
      parameter :service_ordinal, "service_ordinal of the task template"

      required_parameters :auth_token
      scope_parameters :task_template, [:name, :title, :description, :time_estimate, :service_ordinal, :service_template_id]

      let(:name) { task_template.name }
      let(:title) { task_template.title }
      let(:description) { task_template.description }
      let(:time_estimate) { task_template.time_estimate }
      let(:service_template_id) { service_template_id }
      let(:raw_post) { params.to_json }

      example_request '[POST] Create a task_template' do
        explanation 'Create a task_template. Accessible only by Service Admins.'
        expect(status).to eq(200)
        JSON.parse(response_body)['task_template'].should be_a Hash
      end
    end

    put '/api/v1/task_templates/:id' do
      let!(:task_template) { create(:task_template) }

      parameter :name, "name of the task template"
      parameter :title, "title of the task template"
      parameter :description, "description of the task template"
      parameter :time_estimate, "Estimate in minutes for length of service"
      scope_parameters :task_template, [:name, :title, :description, :service_type_id, :time_estimate]

      let(:title) { 'New Task Template Title' }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update service template' do
        explanation 'Update Service Template'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:task_template][:title]).to eq(title)
      end
    end

    delete '/api/v1/task_templates/:id' do
      let(:id) { task_template.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy task template' do
        explanation 'Destroy a Task Template'
        expect(status).to eq(200)
      end
    end
  end
end
