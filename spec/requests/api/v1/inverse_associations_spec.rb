require 'spec_helper'

describe 'InverseAssociations' do
  let!(:user) { create(:member) }
  let!(:association) { create(:association, associate: user) }

  describe 'GET /api/v1/users/:user_id/inverse_associations' do
    def do_request
      get "/api/v1/users/#{user.id}/inverse_associations", auth_token: user.auth_token
    end

    it 'indexes all inverse_associations' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:associations].to_json).to eq([association].serializer.as_json.to_json)
    end
  end

  describe 'PUT /api/v1/users/:user_id/inverse_associations/:id' do
    def do_request(params={})
      put "/api/v1/users/#{user.id}/inverse_associations/#{association.id}", params.merge!(auth_token: user.auth_token)
    end

    it 'updates the inverse_association' do
      do_request(association: {state_event: :disable})
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:association].to_json).to eq(association.reload.serializer.as_json.to_json)
      expect(association.state?(:disabled)).to be_true
    end
  end

  describe 'DELETE /api/v1/users/:user_id/inverse_associations/:id' do
    def do_request(params={})
      delete "/api/v1/users/#{user.id}/inverse_associations/#{association.id}", auth_token: user.auth_token
    end

    it 'destroys the inverse_association' do
      expect{ do_request }.to change(Association, :count).by(-1)
      expect(response).to be_success
      expect(Association.find_by_id(association.id)).to be_nil
    end
  end
end
