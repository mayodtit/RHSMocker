require 'spec_helper'

describe 'Associations' do
  let!(:user) { create(:member) }

  context 'existing record' do
    let!(:email) { 'kyle@test.getbetter.com' }
    let!(:associate) { create(:associate, email: email, owner: user) }
    let!(:association) { create(:association, user: user, associate: associate) }

    describe 'GET /api/v1/associations' do
      def do_request
        get "/api/v1/users/#{user.id}/associations", auth_token: user.auth_token
      end

      let!(:disabled_association) { create(:association, :disabled) }

      it 'indexes enabled user associations' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:associations].to_json).to eq([association].serializer.as_json.to_json)
        ids = body[:associations].map{|a| a[:id]}
        expect(ids).to include(association.id)
        expect(ids).to_not include(disabled_association.id)
      end
    end

    describe 'GET /api/v1/associations/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/associations/#{association.id}", auth_token: user.auth_token
      end

      it 'shows the association' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:association].to_json).to eq(association.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/associations/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/associations/#{association.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:association_type) { create(:association_type) }

      it 'updates the association' do
        do_request(association: {association_type_id: association_type.id})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:association].to_json).to eq(association.reload.serializer.as_json.to_json)
        expect(body[:association][:association_type_id]).to eq(association_type.id)
      end
    end

    describe 'DELETE /api/v1/associations/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/associations/#{association.id}", auth_token: user.auth_token
      end

      it 'destroys the association' do
        expect{ do_request }.to change(Association, :count).by(-1)
        expect(response).to be_success
        expect(Association.find_by_id(association.id)).to be_nil
      end
    end

    describe 'POST /api/v1/associations/:id/invite' do
      def do_request
        post "/api/v1/users/#{user.id}/associations/#{association.id}/invite", auth_token: user.auth_token
      end

      context 'without a Member associate' do
        it 'creates and invites the Member and returns the pair association' do
          expect{ do_request }.to change(Member, :count).by(1)
          expect(response).to be_success
          new_member = associate.member
          expect(new_member).to_not be_nil
          new_association = user.reload.associations.find_by_associate_id!(new_member.id)
          expect(new_association.state?(:pending)).to be_true
          expect(new_association.user).to eq(user)
          expect(new_association.associate).to eq(new_member)
          expect(new_association.association_type).to eq(association.association_type)
          expect(new_association.original).to eq(association)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:association].to_json).to eq(association.reload.pair.serializer.as_json.to_json)
        end
      end

      context 'with a Member associate' do
        let!(:associate_member) { create(:member, email: associate.email) }

        it 'creates a pending association to the associate Member and returns the pair association' do
          expect{ do_request }.to change(Association, :count).by(2)
          expect(response).to be_success
          new_association = user.reload.associations.find_by_associate_id!(associate_member.id)
          expect(new_association.state?(:pending)).to be_true
          expect(new_association.user).to eq(user)
          expect(new_association.associate).to eq(associate_member)
          expect(new_association.association_type).to eq(association.association_type)
          expect(new_association.original).to eq(association)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:association].to_json).to eq(association.reload.pair.serializer.as_json.to_json)
        end
      end
    end
  end

  describe 'POST /api/v1/associations' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/associations", params.merge!(auth_token: user.auth_token)
    end

    context 'with an existing user' do
      let(:associate) { create(:user) }

      it 'creates an association' do
        expect{ do_request(association: {associate_id: associate.id}) }.to change(Association, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        association = Association.find(body[:association][:id])
        expect(body[:association].to_json).to eq(association.serializer.as_json.to_json)
        expect(association.user).to eq(user)
        expect(association.associate).to eq(associate)
      end
    end

    context 'without an existing user' do
      it 'creates an association' do
        expect{ do_request(association: {associate: attributes_for(:user)}) }.to change(Association, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        association = Association.find(body[:association][:id])
        expect(body[:association].to_json).to eq(association.serializer.as_json.to_json)
        expect(association.user).to eq(user)
      end

      it 'creates a new user' do
        expect{ do_request(association: {associate: attributes_for(:user)}) }.to change(User, :count).by(1)
        expect(response).to be_success
      end
    end
  end
end
