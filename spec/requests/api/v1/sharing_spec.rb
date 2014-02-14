require 'spec_helper'

describe 'Sharing' do
  describe 'point-to-point' do
    let!(:brother) { create(:member) }

    context 'associate is not a member' do
      let(:email) { 'sister@test.getbetter.com' }

      it 'works' do
        # brother creates a family member for the sister
        post "/api/v1/users/#{brother.id}/associations", auth_token: brother.auth_token,
                                                         association: {associate: {email: email}}
        expect(response).to be_success
        association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
        expect(association.associate.email).to eq(email)

        # brother invites sister to share
        expect{ post "/api/v1/users/#{brother.id}/associations/#{association.id}/invite", auth_token: brother.auth_token }.to change(Member, :count).by(1)
        expect(response).to be_success
        replacement = association.reload.replacement
        expect(replacement).to_not be_nil
        expect(replacement.user).to eq(brother)
        expect(replacement.associate.email).to eq(email)
        expect(replacement.associate).to be_a(Member)
        expect(replacement.state?(:pending)).to be_true
      end
    end

    context 'associate is a member' do
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

  describe 'third party' do
    let!(:mother) { create(:member) }
    let!(:child) { create(:user, owner: mother) }
    let!(:association) { create(:association, user: mother, associate: child) }

    describe 'invitation workflow' do
      context 'father is not a member' do
        let(:email) { 'father@test.getbetter.com' }

        it 'works' do
          # mother creates a family member for the father
          post "/api/v1/users/#{mother.id}/associations", auth_token: mother.auth_token,
                                                           association: {associate: {email: email}}
          expect(response).to be_success
          association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
          father_family_member = association.associate
          expect(father_family_member.email).to eq(email)

          # mother creates a pending association between father family member and child
          expect{ post "/api/v1/users/#{father_family_member.id}/associations", auth_token: mother.auth_token, association: {associate_id: child.id} }.to change(Member, :count).by(1)
          expect(response).to be_success
          association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
          expect(association.user).to eq(father_family_member)
          expect(association.associate).to eq(child)
          expect(association.creator).to eq(mother)
          expect(association.state?(:pending)).to be_true

          # a member record is created for the father
          father = father_family_member.reload.member
          expect(father).to be_a(Member)
          expect(father.email).to eq(email)

          # a replacement association is automagically created with the father's record
          replacement = association.replacement
          expect(replacement).to_not be_nil
          expect(replacement.user).to eq(father)
          expect(replacement.associate).to eq(child)
          expect(replacement.creator).to eq(mother)
          expect(replacement.state?(:pending)).to be_true

          # an invite to share is created between the mother and father
          invite = Association.where(user_id: mother.id, associate_id: father.id).first
          expect(invite).to_not be_nil
          expect(invite.creator).to eq(mother)
          expect(invite.state?(:pending)).to be_true
        end
      end

      context 'father is a member' do
        let!(:father) { create(:member) }

        context 'mother and father are sharing' do
          let!(:parent_association) { create(:association, :pending, user: mother, associate: father).tap{|a| a.enable!} }

          it 'works' do
            # the mother creates a pending association between the father and child'
            post "/api/v1/users/#{father.id}/associations", auth_token: mother.auth_token, association: {associate_id: child.id}
            expect(response).to be_success
            association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
            expect(association.user).to eq(father)
            expect(association.associate).to eq(child)
            expect(association.creator).to eq(mother)
            expect(association.state?(:pending)).to be_true

            # the father can accept the association
            put "/api/v1/users/#{father.id}/associations/#{association.id}", auth_token: father.auth_token,
                                                                             association: {state_event: :enable}
            expect(response).to be_success
            expect(association.reload.state?(:enabled)).to be_true
          end
        end

        context 'mother and father are not sharing' do
          it 'works' do
            # mother creates a family member for the father
            post "/api/v1/users/#{mother.id}/associations", auth_token: mother.auth_token,
                                                             association: {associate: {email: father.email}}
            expect(response).to be_success
            association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
            father_family_member = association.associate
            expect(father_family_member.email).to eq(father.email)

            # mother creates a pending association between father family member and child
            post "/api/v1/users/#{father_family_member.id}/associations", auth_token: mother.auth_token, association: {associate_id: child.id}
            expect(response).to be_success
            association = Association.find(JSON.parse(response.body, symbolize_names: true)[:association][:id])
            expect(association.user).to eq(father_family_member)
            expect(association.associate).to eq(child)
            expect(association.creator).to eq(mother)
            expect(association.state?(:pending)).to be_true

            # a replacement association is automagically created with the father's record
            replacement = association.replacement
            expect(replacement).to_not be_nil
            expect(replacement.user).to eq(father)
            expect(replacement.associate).to eq(child)
            expect(replacement.creator).to eq(mother)
            expect(replacement.state?(:pending)).to be_true

            # an invite to share is created between the mother and father
            invite = Association.where(user_id: mother.id, associate_id: father.id).first
            expect(invite).to_not be_nil
            expect(invite.creator).to eq(mother)
            expect(invite.state?(:pending)).to be_true

            # the father accepts the association to the child
            put "/api/v1/users/#{father.id}/associations/#{replacement.id}", auth_token: father.auth_token,
                                                                             association: {state_event: :enable}
            expect(response).to be_success
            expect(replacement.reload.state?(:enabled)).to be_true

            # the association between the father family member and child is disabled
            expect(association.reload.state?(:disabled)).to be_true
          end
        end
      end
    end
  end
end
