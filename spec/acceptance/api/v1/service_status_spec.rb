require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "ServiceStatus" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let!(:pha_role) { create(:role) }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  before do
    Role.safe_stub(:pha).and_return(pha_role)
  end

  get '/api/v1/service_status' do
    let!(:time) { Time.now }
    let!(:timezone) { time.zone }
    let!(:timezone_offset) { time.utc_offset }
    let!(:force_status) { nil }

    parameter :time, 'optional client time'
    parameter :timezone, 'optional client timezone'
    parameter :timezone_offset, 'optional client timezone offset'
    parameter :force_status, "optional force status, one of ['online', 'offline'], only available in non-production"

    context 'online' do
      before do
        pha_role.safe_stub(:on_call?).and_return(true)
      end

      example_request '[GET] retrieve the service status (online)' do
        explanation 'Retreive current service information'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:service_status][:status]).to eq('online')
        expect(body[:service_status][:message]).to be_nil
      end
    end

    context 'offline' do
      before do
        pha_role.safe_stub(:on_call?).and_return(false)
      end

      example_request '[GET] retrieve the service status (offline)' do
        explanation 'Retreive current service information'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:service_status][:status]).to eq('offline')
        expect(body[:service_status][:message]).to be_present
      end
    end
  end
end
