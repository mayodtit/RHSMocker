require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Member Tasks" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:member) { create :member }
  let!(:relative) { create :user }
  let!(:other_member) { create :member }
  let!(:pha) { create :pha }
  let!(:other_pha) { create :pha }
  let!(:task) { create :task }
  let!(:another_task) { create :task }
  let!(:one_more_task) { create :task }

  let!(:unassigned_task) { create(:member_task, member: member, subject: relative) }
  let!(:assigned_task) { create(:member_task, :assigned, member: member, subject: relative) }
  let!(:started_task) { create(:member_task, :started, member: member) }
  let!(:claimed_task) { create(:member_task, :claimed, owner: pha, member: member) }
  let!(:completed_task) { create(:member_task, :completed, member: member) }
  let!(:abandoned_task) { create(:member_task, :abandoned, member: member, subject: relative) }

  let!(:other_assigned_task) { create(:member_task, :assigned, member: other_member) }
  let!(:other_unassigned_task) { create(:member_task, member: other_member) }

  let(:auth_token) { pha.auth_token }

  before(:each) do
    pha.login
  end

  describe 'tasks' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'Member to retrieve tasks for'
    parameter :subject_id, 'Subject to retrieve tasks for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { pha.auth_token }
    let(:member_id) { member.id }
    let(:subject_id) { relative.id }

    get '/api/v1/members/:member_id/tasks/' do
      example_request '[GET] Get all tasks for a member' do
        explanation 'Get all tasks for a member (optionally filter by subject and state)'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:tasks].to_json.should == [unassigned_task, assigned_task, abandoned_task].serializer.to_json
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

    required_parameters :auth_token, :member_id, :subject_id, :title, :description, :due_at
    scope_parameters :task, [:subject_id, :title, :description, :due_at, :state_event, :owner_id]

    let(:auth_token) { pha.auth_token }
    let(:member_id) { other_member.id }
    let(:subject_id) { relative.id }
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:due_at) { task_due_at }
    let(:state_event) { 'assign' }
    let(:owner_id) { other_pha.id }

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
        task.state.should == 'assigned'
        task.owner.should == other_pha
      end
    end
  end
end
