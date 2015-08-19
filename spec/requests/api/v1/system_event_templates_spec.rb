require 'spec_helper'

describe 'SystemEventTemplates' do
  let!(:user) { create(:service_admin) }
  let!(:session) { user.sessions.create }

  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  context 'existing record' do
    let!(:system_event_template) { create(:system_event_template) }

    describe 'GET /api/v1/system_event_templates/:id' do
      def do_request
        get "/api/v1/system_event_templates/#{system_event_template.id}", auth_token: session.auth_token
      end

      it 'returns the system event template and related templates' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:system_event_template]).to eq(system_event_template.serializer.as_json)
        expect(body[:all_system_event_templates]).to eq([system_event_template].serializer(sample_time: Time.parse('2015-08-12 12:00:00 -0700')).as_json)
      end
    end
  end
end
