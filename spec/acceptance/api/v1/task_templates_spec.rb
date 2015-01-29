require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "TaskTemplates" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:task_template) { create(:task_template) }
  let(:auth_token) { session.auth_token }

  describe 'task_template' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Service id'

    required_parameters :auth_token, :id

    let(:auth_token) { session.auth_token }
    let(:id) { task_template.id }

    get '/api/v1/task_templates/:id' do
      example_request '[GET] Get a task_template' do
        explanation 'Get a task_template (along with the member\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task_template].to_json.should == task_template.serializer.to_json
      end
    end
  end
end
