require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Member Tasks" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  parameter :auth_token, 'Performing hcp\'s auth_token'
  required_parameters :auth_token

  let!(:pha) { create :pha }
  let(:session) { pha.sessions.create }
  let(:auth_token) { session.auth_token }
  let!(:member) { create :member, pha: pha }

  describe 'tasks' do
    parameter :member_id, 'Member to retrieve tasks for'
    parameter :subject_id, 'Subject to retrieve tasks for'
    required_parameters :member_id

    let!(:task) { create(:member_task, :assigned, member: member, subject: member, due_at: 2.days.ago) }
    let(:member_id) { member.id }

    get '/api/v1/members/:member_id/tasks/' do
      example_request '[GET] Get all tasks for a member' do
        explanation 'Get all tasks for a member (optionally filter by subject and state)'
        expect(status).to eq(200)
        response = JSON.parse(response_body, symbolize_names: true)
        expect(response[:tasks].to_json).to eq([task].serializer(for_subject: true).to_json)
      end
    end
  end

  describe 'create member task' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'The member to create the task for'
    parameter :subject_id, 'The subject of this task'
    parameter :title, 'Task title'
    parameter :description, 'Task description'
    parameter :due_at, 'When this task is due'
    parameter :state_event, 'Event to perform on the task (only \'assign\')'
    parameter :owner_id, 'The id of the owner of this task'
    parameter :service_type_id, 'The service type of the task'
    required_parameters :auth_token, :member_id, :subject_id, :title, :description, :due_at
    scope_parameters :task, [:subject_id, :title, :description, :due_at, :state_event, :owner_id, :service_type_id]

    let(:service_type) { create :service_type }
    let(:task_due_at) { 2.days.from_now }
    let(:member_id) { member.id }
    let(:subject_id) { member.id }
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:due_at) { task_due_at }
    let(:state_event) { 'assign' }
    let(:owner_id) { pha.id }
    let(:service_type_id) { service_type.id }
    let(:raw_post) { params.to_json }

    post '/api/v1/members/:member_id/tasks/' do
      example_request '[POST] Create a member task' do
        explanation 'Create a new task for a member.'
        expect(status).to eq(200)
        body = JSON.parse response_body, symbolize_names: true
        task = Task.find(body[:task][:id])
        expect(body[:task].to_json).to eq(task.serializer.to_json)
        expect(task.member).to eq(member)
        expect(task.subject).to eq(member)
        expect(task.title).to eq(title)
        expect(task.description).to eq(description)
        expect(task.due_at.to_i).to eq(task_due_at.to_i)
        expect(task).to be_unclaimed
        expect(task.owner).to eq(pha)
        expect(task.service_type).to eq(service_type)
      end
    end
  end
end
