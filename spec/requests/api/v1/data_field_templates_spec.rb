require 'spec_helper'

describe 'DataFieldTemplates' do
  let!(:user) { create(:service_admin) }
  let!(:session) { user.sessions.create }
  let!(:service_template) { create(:service_template) }

  describe 'POST /api/v1/service_templates/:service_template_id/data_field_templates' do
    def do_request(params={})
      post "/api/v1/service_templates/#{service_template.id}/data_field_templates", params.merge!(auth_token: session.auth_token)
    end

    let(:name) { 'Test name' }
    let(:type) { 'text' }

    it 'creates a data field template' do
      do_request(data_field_template: {name: name, type: type})
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      new_record = DataFieldTemplate.find(body[:data_field_template][:id])
      expect(body[:data_field_template].to_json).to eq(new_record.serializer.as_json.to_json)
    end
  end

  context 'existing record' do
    let!(:data_field_template) { create(:data_field_template, service_template: service_template) }

    describe 'GET /api/v1/service_templates/:service_template_id/data_field_templates' do
      def do_request
        get "/api/v1/service_templates/#{service_template.id}/data_field_templates", auth_token: session.auth_token
      end

      it 'lists data field templates' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data_field_templates].to_json).to eq([data_field_template.serializer.as_json].to_json)
      end
    end

    describe 'GET /api/v1/service_templates/:service_template_id/data_field_templates/:id' do
      def do_request
        get "/api/v1/service_templates/#{service_template.id}/data_field_templates/#{data_field_template.id}", auth_token: session.auth_token
      end

      it 'shows the data field template' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data_field_template].to_json).to eq(data_field_template.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/service_templates/:service_template_id/data_field_templates/:id' do
      def do_request(params={})
        put "/api/v1/service_templates/#{service_template.id}/data_field_templates/#{data_field_template.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_name) { 'Pick a number between 1 and 10' }

      it 'updates the task step template' do
        do_request(data_field_template: {name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data_field_template].to_json).to eq(data_field_template.reload.serializer.as_json.to_json)
        updated_record = DataFieldTemplate.find(body[:data_field_template][:id])
        expect(updated_record.name).to eq(new_name)
      end
    end

    describe 'DELETE /api/v1/service_templates/:service_template_id/data_field_templates/:id' do
      def do_request
        delete "/api/v1/service_templates/#{service_template.id}/data_field_templates/#{data_field_template.id}", auth_token: session.auth_token
      end

      it 'destroys the task step template' do
        do_request
        expect(response).to be_success
        expect(DataFieldTemplate.find_by_id(data_field_template.id)).to be_nil
      end
    end
  end
end
