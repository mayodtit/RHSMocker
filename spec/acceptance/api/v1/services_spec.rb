require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Services" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:relative) { create :user }
  let!(:member) { create :member, pha: pha }
  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:other_pha) { create(:pha) }
  let!(:service) { create(:service) }
  let(:time) { 4.days.from_now }
  let(:auth_token) { session.auth_token }

  let!(:service) { create :service, member: member, subject: relative }
  let!(:other_service) { create :service, member: member, subject: member }
  let!(:completed_service) { create :service, :completed, member: member, subject: relative }
  let!(:abandoned_service) { create :service, :abandoned, member: member, subject: relative }

  let!(:service_template) { create :service_template }

  describe 'service' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Service id'

    required_parameters :auth_token, :id

    let(:auth_token) { session.auth_token }
    let(:id) { service.id }

    get '/api/v1/services/:id' do
      example_request '[GET] Get a service' do
        explanation 'Get a service (along with the member\'s information). Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:service].to_json.should == service.serializer.to_json
      end
    end
  end

  describe 'update service' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :id, 'Service id'
    parameter :state_event, 'Event to perform on the service (\'reopen\', \'complete\', \'abandon\')'
    parameter :owner_id, 'The id of the owner of this service'
    parameter :due_at, 'When the service is due'
    parameter :reason_abandoned, 'The reason for abandoning a service'

    required_parameters :auth_token, :id
    scope_parameters :service, [:state_event, :owner_id, :due_at, :reason_abandoned]

    let(:auth_token) { session.auth_token }
    let(:id) { service.id }
    let(:state_event) { 'abandon' }
    let(:owner_id) { other_pha.id }
    let(:due_at) { time }
    let(:reason_abandoned) { 'unreachable' }

    let(:raw_post) { params.to_json }

    put '/api/v1/services/:id' do
      example_request '[PUT] Update a service' do
        explanation 'Update a service or transition it through a state. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        service.reload
        service.should be_abandoned
        service.owner.should == other_pha
        service.reason_abandoned.should == 'unreachable'
        service.due_at.to_s.should == time.to_s
        response[:service].to_json.should == service.serializer.to_json
      end
    end
  end

  describe 'services' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'Member to retrieve services for'
    parameter :subject_id, 'Subject to retrieve services for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { member.id }
    let(:subject_id) { relative.id }

    get '/api/v1/members/:member_id/services/' do
      example_request '[GET] Get all services for a member' do
        explanation 'Get all services for a member (optionally filter by subject and state)'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:services].to_json.should == [service, completed_service, abandoned_service].serializer.to_json
      end
    end
  end

  describe 'create service' do

    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'The member to create the task for'
    parameter :title, 'Task title'
    parameter :description, 'Task description'
    parameter :service_template_id, 'The service type of the task'

    required_parameters :auth_token, :member_id, :service_template_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { member.id }
    let(:title) { 'Title' }
    let(:description) { 'Description' }
    let(:service_template_id) { service_template.id }

    let(:raw_post) { params.to_json }

    post '/api/v1/members/:member_id/services/' do
      example_request '[POST] Create a service' do
        explanation 'Create a new service for a member from a service template.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:service].to_json.should == Service.last.serializer.to_json
        service = Service.last
        service.member.should == member
        service.title.should == 'Title'
        service.description.should == 'Description'
        service.service_template.should == service_template
      end
    end
  end
end
