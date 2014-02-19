require 'spec_helper'

describe 'Permissions' do
  let!(:user) { create(:member) }
  let!(:association) { create(:association, associate: user) }

  context 'existing record' do
    let!(:permission) { create(:permission, user: user, subject: association) }

    describe 'GET /api/v1/associations/:association_id/permissions' do
      def do_request
        get "/api/v1/associations/#{association.id}/permissions", auth_token: user.auth_token
      end

      it 'indexes all permissions for an association' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permissions].to_json).to eq([permission].as_json.to_json)
      end
    end

    describe 'PUT /api/v1/associations/:association_id/permissions/:id' do
      def do_request(params={})
        put "/api/v1/associations/#{association.id}/permissions/#{permission.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'updates the permission' do
        do_request(permission: {level: :view})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:permission].to_json).to eq(permission.reload.as_json.to_json)
        expect(permission.reload.level).to eq(:view)
      end
    end

    describe 'DELETE /api/v1/associations/:association_id/permissions/:id' do
      def do_request(params={})
        delete "/api/v1/associations/#{association.id}/permissions/#{permission.id}", auth_token: user.auth_token
      end

      it 'destroys the permission' do
        expect{ do_request }.to change(Permission, :count).by(-1)
        expect(response).to be_success
        expect(Permission.find_by_id(permission.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/associations/:association_id/permissions' do
    def do_request(params={})
      post "/api/v1/associations/#{association.id}/permissions", params.merge!(auth_token: user.auth_token)
    end

    it 'creates the permission' do
      do_request(permission: {name: :basic_info, level: :view})
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      permission = Permission.find(body[:permission][:id])
      expect(body[:permission].to_json).to eq(permission.as_json.to_json)
    end
  end
end
