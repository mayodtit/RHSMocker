require 'spec_helper'

describe 'DataFields' do
  let!(:user) { create(:pha) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:data_field) { create(:data_field) }

    describe 'GET /api/v1/data_fields/:id' do
      def do_request
        get "/api/v1/data_fields/#{data_field.id}", auth_token: session.auth_token
      end

      it 'shows the data_field' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data_field].to_json).to eq(data_field.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/data_fields/:id' do
      def do_request(params={})
        put "/api/v1/data_fields/#{data_field.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_data) { 'Test data' }

      it 'updates the data_field' do
        do_request(data_field: {data: new_data})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(data_field.reload.data).to eq(new_data)
        expect(body[:data_field].to_json).to eq(data_field.serializer.as_json.to_json)
      end
    end
  end
end
