require 'spec_helper'

describe 'ServiceTemplates' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:service_template) { create(:service_template) }

    describe 'GET /api/v1/service_templates' do
      def do_request
        get "/api/v1/service_templates", auth_token: session.auth_token
      end

      it 'indexes message_templates' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service_templates].to_json).to eq([service_template].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/message_templates/:id' do
      def do_request
        get "/api/v1/service_templates/#{service_template.id}", auth_token: session.auth_token
      end

      it 'shows the service_template' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service_template].to_json).to eq(service_template.serializer.as_json.to_json)
      end
    end
  end

end
