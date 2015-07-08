require 'spec_helper'

describe 'ServiceTemplates' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:service_admin) { create(:service_admin) }
  let(:session) { service_admin.sessions.create }

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

    describe 'PUT /api/v1/service_templates/:id' do
      def do_request(params={})
        put "/api/v1/service_templates/#{service_template.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_service_template_title) { "New title" }

      it 'updates the service_template' do
        do_request(service_template: {title: new_service_template_title})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(service_template.reload.title).to eq(new_service_template_title)
        expect(body[:service_template].to_json).to eq(service_template.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/service_templates/:id' do
      def do_request
        delete "/api/v1/service_templates/#{service_template.id}", auth_token: session.auth_token, state: :unpublished
      end

      it 'destroys the service template when state is unpublished' do
        do_request
        expect(response).to be_success
        expect(ServiceTemplate.find_by_id(service_template.id)).to be_nil
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
