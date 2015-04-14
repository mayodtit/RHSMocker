require 'spec_helper'

describe 'Associations' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:email) { 'kyle@test.getbetter.com' }
    let!(:associate) { create(:associate, email: email, owner: user) }
    let!(:association) { create(:association, user: user, associate: associate) }

    describe 'GET /api/v1/associations' do
      def do_request
        get "/api/v1/users/#{user.id}/associations", auth_token: session.auth_token
      end

      let!(:disabled_association) { create(:association, :disabled) }

      it 'indexes enabled user associations' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:associations].to_json).to eq([association].serializer(scope: user).as_json.to_json)
        ids = body[:associations].map{|a| a[:id]}
        expect(ids).to include(association.id)
        expect(ids).to_not include(disabled_association.id)
      end
    end

    describe 'GET /api/v1/associations/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/associations/#{association.id}", auth_token: session.auth_token
      end

      it 'shows the association' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:association].to_json).to eq(association.serializer(scope: user).as_json.to_json)
      end
    end

    describe 'PUT /api/v1/associations/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/associations/#{association.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:association_type) { create(:association_type) }

      it 'updates the association' do
        do_request(association: {association_type_id: association_type.id})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:association].to_json).to eq(association.reload.serializer(scope: user).as_json.to_json)
        expect(body[:association][:association_type_id]).to eq(association_type.id)
      end
    end

    describe 'DELETE /api/v1/associations/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/associations/#{association.id}", auth_token: session.auth_token
      end

      it 'destroys the association' do
        expect{ do_request }.to change(Association, :count).by(-1)
        expect(response).to be_success
        expect(Association.find_by_id(association.id)).to be_nil
      end
    end

    describe 'POST /api/v1/associations/:id/invite' do
      def do_request
        post "/api/v1/users/#{user.id}/associations/#{association.id}/invite", auth_token: session.auth_token
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
          expect(body[:association].to_json).to eq(association.reload.pair.serializer(scope: user).as_json.to_json)
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
          expect(body[:association].to_json).to eq(association.reload.pair.serializer(scope: user).as_json.to_json)
        end
      end
    end
  end

  describe 'POST /api/v1/associations' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/associations", params.reverse_merge!(auth_token: session.auth_token)
    end

    context 'for the current user' do
      context 'with an existing user' do
        let(:associate) { create(:user, owner: user) }

        it 'creates an association' do
          expect{ do_request(association: {associate_id: associate.id}) }.to change(Association, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          association = Association.find(body[:association][:id])
          expect(body[:association].to_json).to eq(association.serializer(scope: user).as_json.to_json)
          expect(association.user).to eq(user)
          expect(association.associate).to eq(associate)
        end

        context 'not owned by the user' do
          let(:other_member) { create(:member) }
          let(:associate) { create(:user, owner: other_member) }

          it 'raises 403' do
            expect{ do_request(association: {associate_id: associate.id}) }.to_not change(Association, :count)
            expect(response).to_not be_success
            expect(response.status).to eq(403)
          end
        end
      end

      context 'without an existing user' do
        it 'creates an association' do
          expect{ do_request(association: {associate: attributes_for(:user)}) }.to change(Association, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          association = Association.find(body[:association][:id])
          expect(body[:association].to_json).to eq(association.serializer(scope: user).as_json.to_json)
          expect(association.user).to eq(user)
        end

        it 'creates a new user' do
          expect{ do_request(association: {associate: attributes_for(:user)}) }.to change(User, :count).by(1)
          expect(response).to be_success
        end
      end

      context 'with an NPI number' do
        context 'with an existing NPI user' do
          let(:npi_number) { '1234567890' }
          let!(:provider) { create(:member, :chamath, npi_number: npi_number) }

          it 'creates an association' do
            expect{ do_request(association: {associate: {npi_number: npi_number}}) }.to change(Association, :count).by(1)
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            association = Association.find(body[:association][:id])
            expect(body[:association].to_json).to eq(association.serializer(scope: user).as_json.to_json)
            expect(association.user).to eq(user)
          end
        end

        context 'without an existing provider' do
          let(:npi_number) { '1588730618' }
          let(:search_results) {
            {
              :first_name => "Jeffrey",
              :last_name => "Croke",
              :npi_number => "1588730618",
              :address => {
                :address => "795 El Camino Real",
                :address2 => nil,
                :city => "Palo Alto",
                :state => "CA",
                :postal_code => "943012302",
                :country_code => nil,
                :phone => "6503214121",
                :fax => nil
              },
              :city => "Palo Alto",
              :state => "CA",
              :phone => "6503214121",
              :expertise => "M.D.",
              :gender => "male",
              :healthcare_taxonomy_code => "207R00000X",
              :provider_taxonomy_code => "207R00000X",
              :taxonomy_classification => nil
            }
          }

          before do
            Search::Service.any_instance.stub(find: search_results)
          end

          it 'creates an association and provider from results' do
            expect{ do_request(association: {associate: {npi_number: npi_number}}) }.to change(Association, :count).by(1)
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            association = Association.find(body[:association][:id])
            expect(body[:association].to_json).to eq(association.serializer(scope: user).as_json.to_json)
            expect(association.user).to eq(user)
            expect(association.associate.npi_number).to eq(npi_number)
            expect(association.associate.addresses.count).to eq(1)
          end
        end
      end
    end

    context 'for a third party' do
      let!(:member) { create(:member) }
      let!(:session) { member.sessions.create }
      let!(:user) { create(:user, owner: member, email: 'kyle+1@test.getbetter.com') }
      let!(:first_association) { create(:association, user: member, associate: user) }
      let!(:associate) { create(:user, owner: member, email: 'kyle+2@test.getbetter.com') }
      let!(:second_association) { create(:association, user: member, associate: associate) }

      it 'creates the association' do
        do_request(association: {associate_id: associate.id}, auth_token: session.auth_token)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        association = Association.find(body[:association][:id])
        expect(body[:association].to_json).to eq(association.serializer(scope: member).as_json.to_json)
        expect(association.creator).to eq(member)
        expect(association.user).to eq(user)
        expect(association.associate).to eq(associate)
      end

      context 'associate is shared' do
        it 'raises 403' do
          second_association.invite!
          expect{ do_request(association: {associate_id: associate.id}, auth_token: session.auth_token) }.to_not change(Association, :count)
          expect(response).to_not be_success
          expect(response.status).to eq(403)
        end
      end
    end
  end
end
