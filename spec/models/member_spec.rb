require 'spec_helper'

describe Member do
  let(:member) { build_stubbed :member }

  context 'agreement exists' do
    before do
      @agreement = Agreement.create text: 'TOS', type: :terms_of_service, active: true
    end

    describe '#terms_of_service_and_privacy_policy' do
      it 'returns false when no UserAgreement exists for the latest Agreement' do
        m = Member.new email: 'abhik@example.com'
        m.terms_of_service_and_privacy_policy.should be_false
      end

      it 'returns true when UserAgreement exists for the latest Agreement' do
        m = Member.new email: 'abhik@example.com'
        m.user_agreements.new agreement: @agreement, user_agent: 'test', ip_address: 'localhost'
        m.terms_of_service_and_privacy_policy.should be_true
      end
    end

    describe 'account creation' do
      describe 'ghost users' do
        def create_ghost()
          m = Member.find_or_create_by_email 'abhik@example.com'
          m.id.should_not be_nil
          m
        end

        it 'can be created' do
          create_ghost
        end

        it 'cannot sign up without accepting TOS' do
          m = create_ghost
          m.update_attributes password: 'password', password_confirmation: 'password'
          m.should_not be_valid
        end

        it 'can sign up up with accepting TOS' do
          m = create_ghost
          m.update_attributes  agreement_params: {ids: [@agreement.id], ip_address: 'local', user_agent: 'test'}, password: 'password', password_confirmation: 'password'
          m.should be_valid
        end
      end

      describe 'users' do
        it 'can\'t sign up without accepting TOS' do
          m = Member.create email: 'abhik@example.com', password: 'password', password_confirmation: 'password'
          m.should_not be_valid
        end

        it 'can sign up with accepted TOS' do
          m = Member.create email: 'abhik@example.com', password: 'password', password_confirmation: 'password', agreement_params: {ids: [@agreement.id], ip_address: 'local', user_agent: 'test'}, password: 'password', password_confirmation: 'password'
          m.should be_valid
        end
      end
    end
  end

  describe '#signed_up?' do
    it 'returns true when crypted password is present' do
      member.crypted_password = true
      member.should be_signed_up
    end

    it 'returns false when crypted password is present' do
      member.crypted_password = false
      member.should_not be_signed_up
    end
  end

  describe '#invite!' do
    let(:email) { double('email', :deliver => true) }
    let(:invitation) { build_stubbed :invitation }

    before do
      UserMailer.stub(:invitation_email).and_return email
    end

    context 'member signed up' do
      before do
        member.stub(:signed_up?) { true }
      end

      it 'does nothing if member has signed up' do
        UserMailer.should_not_receive :invitation_email
        member.should_not_receive :update_attributes!
        member.invite! invitation
      end
    end

    context 'member has not signed up' do
      before do
        member.stub(:signed_up?) { false }
      end

      it 'updates the invitation token attr with the invitation token' do
        member.should_receive(:update_attributes!).with :invitation_token => invitation.token
        member.invite! invitation
      end

      it 'sends and delivers an invitation' do
        UserMailer.should_receive(:invitation_email).with member, invitation.member
        email.should_receive :deliver
        member.invite! invitation
      end
    end
  end
end
