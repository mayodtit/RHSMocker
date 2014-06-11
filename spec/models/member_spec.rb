require 'spec_helper'

describe Member do
  let(:member) { build_stubbed :member }

  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_test_user)
      described_class.any_instance.stub(:set_marked_for_deletion)
    end

    it_validates 'foreign key of', :pha
    it_validates 'foreign key of', :onboarding_group
    it_validates 'foreign key of', :referral_code
    it_validates 'inclusion of', :test_user
    it_validates 'inclusion of', :marked_for_deletion
    it_validates 'allows blank uniqueness of', :apns_token

    it 'validates member flag is true' do
      member.stub(:set_member_flag)
      expect(member).to be_valid
      member.member_flag = nil
      expect(member).to_not be_valid
    end
  end

  describe 'callbacks' do
    describe '#set_free_trial_ends_at' do
      let(:user) { create(:member, password: nil) }
      let(:onboarding_group) { create(:onboarding_group, :premium, free_trial_days: 3) }

      it 'sets the free_trial_ends_at from onboarding_group on signed up' do
        user.update_attributes(onboarding_group: onboarding_group)
        expect(user.free_trial_ends_at).to be_nil
        user.update_attributes(password: 'password')
        expect(user.free_trial_ends_at).to eq(Time.now.in_time_zone('Pacific Time (US & Canada)').end_of_day + 3.days)
      end

      context 'feature group not set' do
        it 'does not set free_trial_ends_at' do
          expect(user.free_trial_ends_at).to be_nil
          user.update_attributes(password: 'password')
          expect(user.free_trial_ends_at).to be_nil
        end
      end

      context 'not premium' do
        before do
          user.update_attributes(is_premium: false)
          onboarding_group.update_attributes(premium: false)
        end

        it 'does not set free_trial_ends_at' do
          user.update_attributes(onboarding_group: onboarding_group)
          expect(user.free_trial_ends_at).to be_nil
          user.update_attributes(password: 'password')
          expect(user.free_trial_ends_at).to be_nil
        end
      end

      context 'feature group free_trial_days = 0' do
        before do
          onboarding_group.update_attributes(free_trial_days: 0)
        end

        it 'does not set free_trial_ends_at' do
          user.update_attributes(onboarding_group: onboarding_group)
          expect(user.free_trial_ends_at).to be_nil
          user.update_attributes(password: 'password')
          expect(user.free_trial_ends_at).to be_nil
        end
      end
    end
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
    it 'returns true when signed_up_at is present' do
      member.signed_up_at = Time.now
      expect(member).to be_signed_up
    end

    it 'returns false if signed_up_at is not' do
      member.crypted_password = nil
      expect(member).to_not be_signed_up
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

      context 'member is a care provider' do
        before do
          member.stub(:care_provider?) { true }
        end

        it 'sends and delivers an invitation' do
          UserMailer.should_receive(:delay) do
            o = Object.new
            o.should_receive(:invitation_email).with member, invitation.member
            o
          end
          member.invite! invitation
        end
      end

      context 'member is not a care provider' do
        before do
          member.stub(:care_provider?) { false }
        end

        it 'sends and delivers an invitation' do
          UserMailer.should_not_receive(:delay)
          member.invite! invitation
        end
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

    before do
      assigned_pha.create_pha_profile
      unassigned_pha.create_pha_profile
    end

    it 'returns the PHA with the most availablity' do
      expect(described_class.next_pha).to eq(unassigned_pha)
    end
  end

  describe '#notify_pha_of_new_member' do
    let(:member) { build(:member) }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'just assigned a new pha' do
      before do
        member.stub(:newly_assigned_pha?) { true }
      end

      context 'member is signed up' do
        before do
          member.stub(:signed_up?) { true }
        end

        it 'creates a new member task' do
          NewMemberTask.should_receive(:delay) do
            o = Object.new
            o.should_receive(:create!).with member: member, title: 'New Premium Member', creator: Member.robot, due_at: Time.now
            o
          end
          member.notify_pha_of_new_member
        end
      end

      context 'member is not signed up' do
        before do
          member.stub(:signed_up?) { false }
        end

        it 'does nothing' do
          NewMemberTask.should_not_receive :delay
          member.notify_pha_of_new_member
        end
      end
    end

    context 'not just assigned a pha' do
      before do
        member.stub(:newly_assigned_pha?) { false }
      end

      context 'just signed up' do
        before do
          member.stub(:newly_signed_up?) { true }
        end

        context 'pha is assigned' do
          before do
            member.stub(:pha_id) { 1 }
          end

          it 'creates a new member task' do
            NewMemberTask.should_receive(:delay) do
              o = Object.new
              o.should_receive(:create!).with member: member, title: 'New Premium Member', creator: Member.robot, due_at: Time.now
              o
            end
            member.notify_pha_of_new_member
          end
        end

        context 'pha is not assigned' do
          before do
            member.stub(:pha_id) { nil }
          end

          it 'does nothing' do
            NewMemberTask.should_not_receive :delay
            member.notify_pha_of_new_member
          end
        end
      end

      context 'has already signed up' do
        before do
          member.stub(:newly_signed_up?) { false }
        end

        it 'does nothing' do
          NewMemberTask.should_not_receive :delay
          member.notify_pha_of_new_member
        end
      end
    end
  end

  describe '#add_role' do
    let(:member) { create :member }
    let(:role) { create :role, name: 'role' }

    context 'user has role' do
      before do
        member.stub(:has_role?).with('role') { true }
      end

      it 'does nothing' do
        Role.should_not_receive(:where)
        member.add_role 'role'
      end
    end

    context 'user doesn\'t have role' do
      before do
        member.should_not be_has_role('role')
      end

      it 'adds the role' do
        member.add_role 'role'
        member.should be_has_role('role')
      end
    end
  end

  describe '#has_role?' do
    it 'returns true if user has the role' do
      member = build :member
      member.stub(:role_names) { ['role'] }
      member.should be_has_role('role')
    end

    it 'returns false if user has the role' do
      member = build :member
      member.stub(:role_names) { ['other_role'] }
      member.should_not be_has_role('role')
    end
  end

  describe '#on_call?' do
    let(:member) { build :member, on_call: false }

    context 'nurse' do
      before do
        member.stub(:nurse?) { true }
      end

      it 'is true even if on call attribute is false' do
        member.should be_on_call
      end
    end

    context 'not nurse' do
      before do
        member.stub(:nurse?) { false }
      end

      context 'on call attr is false' do
        before do
          member.on_call = true
        end

        it 'is true' do
          member.should be_on_call
        end
      end

      context 'on call attr is true' do
        before do
          member.on_call = false
        end

        it 'is true' do
          member.should_not be_on_call
        end
      end
    end
  end
end
