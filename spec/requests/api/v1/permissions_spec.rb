require 'spec_helper'

describe 'Permissions' do
  context 'association' do
    let!(:user) { create(:member) }
    let(:session) { user.sessions.create }
    let!(:association) { create(:association, user: user) }
    let!(:permission) { association.permission }

    describe 'GET /api/v1/associations/:association_id/permission' do
      def do_request
        get "/api/v1/associations/#{association.id}/permission", auth_token: session.auth_token
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
        put "/api/v1/associations/#{association.id}/permission", params.merge!(auth_token: session.auth_token)
      end

      it 'is successful' do
        do_request(permission: {basic_info: :view})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.reload.serializer.as_json.to_json)
      end

      context 'user does not own associate' do
        let!(:associate) { create(:member) }
        let!(:association) { create(:association, user: user, associate: associate) }

        it 'returns forbidden' do
          do_request(permission: {basic_info: :view})
          expect(response).to_not be_success
          expect(response.status).to eq(403)
        end
      end
    end
  end

  context 'inverse association' do
    let!(:user) { create(:member) }
    let(:session) { user.sessions.create }
    let!(:association) { create(:association, associate: user) }
    let!(:permission) { association.permission }

    describe 'GET /api/v1/associations/:association_id/permission' do
      def do_request
        get "/api/v1/associations/#{association.id}/permission", auth_token: session.auth_token
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
        put "/api/v1/associations/#{association.id}/permission", params.merge!(auth_token: session.auth_token)
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
    let(:session) { user.sessions.create }
    let!(:associate) { create(:user, owner: user) }
    let!(:association) { create(:association, associate: user) }
    let!(:permission) { association.permission }

    describe 'GET /api/v1/associations/:association_id/permission' do
      def do_request
        get "/api/v1/associations/#{association.id}/permission", auth_token: session.auth_token
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
        put "/api/v1/associations/#{association.id}/permission", params.merge!(auth_token: session.auth_token)
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
