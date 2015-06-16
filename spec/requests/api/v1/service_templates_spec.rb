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

    describe 'GET /api/v1/service_templates/:id' do
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

  context 'create a new record' do
    describe 'POST /api/v1/service_templates' do
      def do_request(params={})
        post "/api/v1/service_templates", params.merge!(auth_token: session.auth_token)
      end
      let!(:service_type) { create :service_type}
      let(:service_template_attributes) { attributes_for(:service_template).merge!(service_type_id: service_type.id)}

      it 'creates a service template' do
        expect{ do_request(service_template: service_template_attributes) }.to change(ServiceTemplate, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service_template][:service_template]).to eq(service_template_attributes[:service_template])
      end
    end
  end
end
