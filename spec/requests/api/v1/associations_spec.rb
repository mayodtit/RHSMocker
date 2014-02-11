require 'spec_helper'

describe 'Associations' do
  let!(:user) { create(:member) }

  context 'existing record' do
    let!(:email) { 'kyle@test.getbetter.com' }
    let!(:associate) { create(:associate, email: email) }
    let!(:association) { create(:association, user: user, associate: associate) }

    describe 'POST /api/v1/associations/:id/invite' do
      def do_request
        post "/api/v1/users/#{user.id}/associations/#{association.id}/invite", auth_token: user.auth_token
      end

      context 'without a Member associate' do
        it 'returns 404' do
          do_request
          expect(response).to_not be_success
          expect(response.code).to eq('404')
        end
      end

      context 'with a Member associate' do
        let!(:associate_member) { create(:member, email: associate.email) }

        it 'creates a pending MemberAssociation to the associate Member' do
          expect{ do_request }.to change(Association, :count).by(1)
          expect(response).to be_success
          new_association = user.reload.associations.find_by_associate_id!(associate_member.id)
          expect(new_association.state?(:pending)).to be_true
          expect(new_association.user).to eq(user)
          expect(new_association.associate).to eq(associate_member)
          expect(new_association.association_type).to eq(association.association_type)
          expect(new_association.original).to eq(association)
        end
      end
    end
  end
end
