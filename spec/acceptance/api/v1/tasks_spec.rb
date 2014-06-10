require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Tasks" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:pha) { create(:pha) }
  let!(:other_pha) { create(:pha) }
  let!(:task) { create(:task) }
  let!(:another_task) { create(:task) }
  let!(:one_more_task) { create(:task) }

  let!(:assigned_task) { create(:task, :assigned) }
  let!(:started_task) { create(:task, :started) }
  let!(:claimed_task) { create(:task, :claimed, owner: pha) }
  let!(:completed_task) { create(:task, :completed) }
  let!(:abandoned_task) { create(:task, :abandoned) }

  let(:auth_token) { pha.auth_token }

  before(:each) do
    pha.login
  end

  describe 'tasks' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :state, 'Filter by the state of task (e.g. \'unstarted\',\'started\', \'completed\')'

    required_parameters :auth_token

    let(:auth_token) { pha.auth_token }
    let(:state) { 'unstarted' }

    get '/api/v1/tasks/' do
      example_request '[GET] Get all tasks' do
        explanation 'Get all tasks (along with the member\'s information), most recent first. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:tasks].to_json.should == [task, another_task, one_more_task, assigned_task].serializer(shallow: true).to_json
      end
    end
  end

  describe 'queue' do
    let!(:assigned_task) { create(:task, :assigned, owner: pha, due_at: 3.days.ago) }
    let!(:started_task) { create(:task, :started, owner: pha, due_at: 2.days.ago) }

    parameter :auth_token, 'Performing hcp\'s auth_token'

    required_parameters :auth_token

    let(:auth_token) { pha.auth_token }

    get '/api/v1/tasks/queue' do
      example_request '[GET] Get the tasks queue for the current user' do
        explanation 'Get the task queue for the current user. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:tasks].to_json.should == [assigned_task, started_task, task, another_task, one_more_task].serializer(shallow: true).to_json
      end
    end
  end

  describe 'task' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Task id'

    required_parameters :auth_token, :id

    let(:auth_token) { pha.auth_token }
    let(:id) { task.id }

    get '/api/v1/tasks/:id' do
      example_request '[GET] Get a task' do
        explanation 'Get a task (along with the member\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task].to_json.should == task.serializer.to_json
      end
    end
  end

  describe 'current task' do
    parameter :auth_token, 'Performing hcp\'s auth_token'

    required_parameters :auth_token

    let(:auth_token) { pha.auth_token }

    get '/api/v1/tasks/current' do
      example_request '[GET] Get the current claimed task of the pha.' do
        explanation 'Get the current claimed task of the pha. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task].to_json.should == claimed_task.serializer.to_json
      end
    end
  end

  describe 'update task' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Task id'
    parameter :state_event, 'Event to perform on the task (\'unassign\', \'assign\', \'start\', \'claim\', \'abandon\', \'claim\')'
    parameter :owner_id, 'The id of the owner of this task'
    parameter :reason_abandoned, 'The reason for abandoning a task'

    required_parameters :auth_token, :id
    scope_parameters :task, [:state_event, :owner_id, :reason_abandoned]

    let(:auth_token) { pha.auth_token }
    let(:id) { task.id }
    let(:state_event) { 'abandon' }
    let(:owner_id) { other_pha.id }
    let(:reason_abandoned) { 'unreachable' }

    let(:raw_post) { params.to_json }

    put '/api/v1/tasks/:id' do
      example_request '[PUT] Update a task' do
        explanation 'Update a task or transition it through a state. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        task.reload
        task.should be_abandoned
        task.owner.should == other_pha
        task.reason_abandoned.should == 'unreachable'
        response[:task].to_json.should == task.serializer.to_json
      end
    end
  end
end
