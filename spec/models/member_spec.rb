require 'spec_helper'

describe Member do
  let(:member) { build_stubbed :member }

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
