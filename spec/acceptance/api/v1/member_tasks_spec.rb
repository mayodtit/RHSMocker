require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Member Tasks" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    ViewTaskTask.stub(:create_task_for_task)
  end

  let!(:service_type) { create :service_type }

  let!(:member) { create :member }
  let!(:relative) { create :user }
  let!(:other_member) { create :member }
  let!(:pha) { create :pha }
  let(:session) { pha.sessions.create }
  let!(:other_pha) { create :pha }
  let!(:task) { create :task }
  let!(:another_task) { create :task }
  let!(:one_more_task) { create :task }

  let!(:unstarted_task) { create(:member_task, member: member, subject: relative, due_at: 3.days.ago) }
  let!(:assigned_task) { create(:member_task, :assigned, member: member, subject: relative, due_at: 2.days.ago) }
  let!(:started_task) { create(:member_task, :started, member: member) }
  let!(:claimed_task) { create(:member_task, :claimed, owner: pha, member: member) }
  let!(:completed_task) { create(:member_task, :completed, member: member) }
  let!(:abandoned_task) { create(:member_task, :abandoned, member: member, subject: relative, due_at: 1.days.ago) }
  let!(:freshly_completed_task) { create(:member_task, :abandoned, member: member, subject: relative, due_at: 1.hour.ago) }

  let!(:other_assigned_task) { create(:member_task, :assigned, member: other_member) }
  let!(:other_unstarted_task) { create(:member_task, member: other_member) }

  let(:auth_token) { session.auth_token }

  describe 'tasks' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'Member to retrieve tasks for'
    parameter :subject_id, 'Subject to retrieve tasks for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { member.id }
    let(:subject_id) { relative.id }

    get '/api/v1/members/:member_id/tasks/' do
      example_request '[GET] Get all tasks for a member' do
        explanation 'Get all tasks for a member (optionally filter by subject and state)'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:tasks].to_json.should == [assigned_task, unstarted_task, freshly_completed_task, abandoned_task].serializer(for_subject: true).to_json
      end
    end
  end

  describe 'create member task' do
    let(:task_due_at) { 2.days.from_now }

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

    let(:auth_token) { session.auth_token }
    let(:member_id) { other_member.id }
    let(:subject_id) { relative.id }
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:due_at) { task_due_at }
    let(:state_event) { 'assign' }
    let(:owner_id) { other_pha.id }
    let(:service_type_id) { service_type.id }

    let(:raw_post) { params.to_json }

    post '/api/v1/members/:member_id/tasks/' do
      example_request '[POST] Create a member task' do
        explanation 'Create a new task for a member.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task].to_json.should == Task.last.serializer.to_json
        task = Task.last
        task.member.should == other_member
        task.subject.should == relative
        task.title.should == 'Title'
        task.description.should == 'Description'
        task.due_at.to_s.should == task_due_at.to_s
        task.state.should == 'unstarted'
        task.owner.should == other_pha
        task.service_type.should == service_type
      end
    end
  end
end
