require 'spec_helper'

describe 'Sharing' do
  describe 'point-to-point' do
    let!(:brother) { create(:member) }
    let!(:sister) { create(:member) }

    describe 'invitation workflow' do
      it 'works' do
        # brother creates a family member for the sister
        post "/api/v1/users/#{brother.id}/associations", auth_token: brother.auth_token,
                                                         association: {associate: {email: sister.email}}
        expect(response).to be_success
        association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
        expect(association.associate.email).to eq(sister.email)

        # brother invites sister to share
        post "/api/v1/users/#{brother.id}/associations/#{association.id}/invite", auth_token: brother.auth_token
        expect(response).to be_success
        replacement = association.reload.replacement
        expect(replacement).to_not be_nil
        expect(replacement.user).to eq(brother)
        expect(replacement.associate).to eq(sister)
        expect(replacement.state?(:pending)).to be_true

        # sister can see invitation
        get "/api/v1/users/#{sister.id}/inverse_associations", auth_token: sister.auth_token
        expect(response).to be_success
        expect(JSON.parse(response.body, symbolize_names: true)[:associations].map{|a| a[:id]}).to include(replacement.id)

        # sister can accept the invitation
        put "/api/v1/users/#{sister.id}/inverse_associations/#{replacement.id}", auth_token: sister.auth_token,
                                                                                 association: {state_event: :enable}
        expect(response).to be_success
        expect(association.reload.state?(:disabled)).to be_true
        expect(replacement.reload.state?(:enabled)).to be_true

        # replacement association is activated for brother
        get "/api/v1/users/#{brother.id}/associations", auth_token: brother.auth_token
        expect(response).to be_success
        ids = JSON.parse(response.body, symbolize_names: true)[:associations].map{|a| a[:id]}
        expect(ids).to include(replacement.id)
        expect(ids).to_not include(association.id)

        # pair association is activated for sister
        get "/api/v1/users/#{sister.id}/associations", auth_token: sister.auth_token
        expect(response).to be_success
        ids = JSON.parse(response.body, symbolize_names: true)[:associations].map{|a| a[:id]}
        expect(ids).to include(replacement.reload.pair.id)
        expect(ids).to_not include(replacement.id, association.id)
      end
    end

    describe 'with a sharing relationship' do
      let!(:association) { create(:association, :pending, user: brother, associate: sister).tap{|a| a.enable! } }

      it 'allows the brother to modify the sister' do
        put "/api/v1/users/#{sister.id}", auth_token: brother.auth_token,
                                          user: {first_name: 'butt'}
        expect(response).to be_success
        expect(sister.reload.first_name).to eq('butt')
      end

      it 'allows the sister to modify the brother' do
        put "/api/v1/users/#{brother.id}", auth_token: sister.auth_token,
                                           user: {first_name: 'jerk'}
        expect(response).to be_success
        expect(brother.reload.first_name).to eq('jerk')
      end

      it 'removes the pair if an association is removed' do
        delete "/api/v1/users/#{brother.id}/associations/#{association.id}", auth_token: brother.auth_token
        expect(response).to be_success
        expect(Association.find_by_id(association.id)).to be_nil
        expect(Association.find_by_id(association.pair_id)).to be_nil
      end

      it 'removes the pair if an inverse association is removed' do
        delete "/api/v1/users/#{sister.id}/inverse_associations/#{association.id}", auth_token: sister.auth_token
        expect(response).to be_success
        expect(Association.find_by_id(association.id)).to be_nil
        expect(Association.find_by_id(association.pair_id)).to be_nil
      end
    end
  end
end
