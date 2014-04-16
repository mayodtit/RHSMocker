require 'spec_helper'

describe Member do
  let(:member) { build_stubbed :member }

  it_has_a 'valid factory'
  it_validates 'foreign key of', :pha
  it_validates 'allows blank uniqueness of', :apns_token

  it 'validates member flag is true' do
    member.stub(:set_member_flag)
    expect(member).to be_valid
    member.member_flag = nil
    expect(member).to_not be_valid
  end

  context 'agreement exists' do
    before do
      @agreement = create(:agreement, :active)
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
          m.update_attributes user_agreements_attributes: [{agreement_id: @agreement.id, ip_address: 'local', user_agent: 'test'}], password: 'password', password_confirmation: 'password'
          m.should be_valid
        end
      end

      describe 'users' do
        it 'can\'t sign up without accepting TOS' do
          m = Member.create email: 'abhik@example.com', password: 'password', password_confirmation: 'password'
          m.should_not be_valid
        end

        it 'can sign up with accepted TOS' do
          m = Member.create email: 'abhik@example.com', password: 'password', password_confirmation: 'password', user_agreements_attributes: [{agreement_id: @agreement.id, ip_address: 'local', user_agent: 'test'}], password: 'password', password_confirmation: 'password'
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

      xit 'sends and delivers an invitation' do
        UserMailer.should_receive(:invitation_email).with member, invitation.member
        email.should_receive :deliver
        member.invite! invitation
      end
    end
  end

  describe 'database constraints' do
    it 'validates uniquness of email' do
      member1 = create(:member)
      member2 = build(:member, email: member1.email)
      expect{ member2.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe '#store_apns_token!' do
    let(:member) { create(:member) }
    let(:token) { 'test_token' }

    it 'saves the token' do
      member.store_apns_token!(token)
      expect(member.reload.apns_token).to eq(token)
    end

    context 'another member has the token' do
      let!(:other_member) { create(:member, apns_token: token) }

      it "expires the other member's token" do
        member.store_apns_token!(token)
        expect(member.reload.apns_token).to eq(token)
        expect(other_member.reload.apns_token).to be_nil
      end
    end
  end

  describe '::phas' do
    let!(:pha) { create(:pha) }

    it 'returns all PHAs using Roles' do
      expect(described_class.phas).to include(pha)
    end
  end

  describe '::pha_counts' do
    let!(:pha) { create(:pha) }

    it 'returns a hash of PHA assignment counts with nil defaults' do
      result = described_class.pha_counts
      expect(result).to be_a(Hash)
      expect(result).to be_empty
      expect(result[pha.id]).to be_zero
    end
  end

  describe '::next_pha' do
    let!(:assigned_pha) { create(:pha) }
    let!(:member) { create(:member, pha: assigned_pha) }
    let!(:unassigned_pha) { create(:pha) }

    it 'returns the PHA with the most availablity' do
      expect(described_class.next_pha).to eq(unassigned_pha)
    end
  end
end
