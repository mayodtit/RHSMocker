require 'spec_helper'

describe 'Permissions' do
  context 'inverse association' do
    let!(:user) { create(:member) }
    let!(:association) { create(:association, associate: user) }
    let!(:permission) { association.permission }

    describe 'GET /api/v1/associations/:association_id/permission' do
      def do_request
        get "/api/v1/associations/#{association.id}/permission", auth_token: user.auth_token
      end

      it 'shows the permission for the association' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/associations/:association_id/permission' do
      def do_request(params={})
        put "/api/v1/associations/#{association.id}/permission", params.merge!(auth_token: user.auth_token)
      end

      it 'updates the permission' do
        do_request(permission: {basic_info: :view})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.reload.serializer.as_json.to_json)
        expect(permission.reload.basic_info).to eq(:view)
      end
    end
  end

  context 'shared association' do
    let!(:user) { create(:member) }
    let!(:associate) { create(:user, owner: user) }
    let!(:association) { create(:association, associate: user) }
    let!(:permission) { association.permission }

    describe 'GET /api/v1/associations/:association_id/permission' do
      def do_request
        get "/api/v1/associations/#{association.id}/permission", auth_token: user.auth_token
      end

      it 'shows the permission for the association' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/associations/:association_id/permission' do
      def do_request(params={})
        put "/api/v1/associations/#{association.id}/permission", params.merge!(auth_token: user.auth_token)
      end

      it 'updates the permission' do
        do_request(permission: {basic_info: :view})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.reload.serializer.as_json.to_json)
        expect(permission.reload.basic_info).to eq(:view)
      end
    end
  end
end
