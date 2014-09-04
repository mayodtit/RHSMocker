require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Services" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:other_pha) { create(:pha) }
  let!(:service) { create(:service) }
  let(:time) { 4.days.from_now }
  let(:auth_token) { session.auth_token }

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
end
