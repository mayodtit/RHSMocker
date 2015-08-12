require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "TaskCategories" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let(:auth_token) { session.auth_token }

  describe 'index' do

    parameter :auth_token, 'Performing hcp\'s auth_token'

    required_parameters :auth_token

    let!(:task_category) { create(:task_category) }
    let!(:another_task_category) { create(:task_category) }

    get '/api/v1/task_categories/' do
      example_request '[GET] Get all task categories' do
        explanation 'Get all task categories'
        expect(status).to eq(200)
        response = JSON.parse response_body, symbolize_names: true
        response[:task_categories].to_json.should == [task_category, another_task_category].serializer.to_json
      end
    end
  end

  describe 'show' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Task Category id'

    required_parameters :auth_token, :id

    let(:task_category) { create(:task_category) }
    let(:id) { task_category.id }

    get '/api/v1/task_categories/:id' do
      example_request '[GET] Get a task category' do
        explanation 'Get a task category based on id'
        expect(status).to eq(200)
        response = JSON.parse response_body, symbolize_names: true
        response[:task_category].to_json.should == task_category.serializer.to_json
      end
    end
  end
end
