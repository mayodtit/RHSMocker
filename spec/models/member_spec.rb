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
  it_has_a 'valid factory', :invited
  it_has_a 'valid factory', :free
  it_has_a 'valid factory', :trial
  it_has_a 'valid factory', :premium
  it_has_a 'valid factory', :chamath

  describe 'validations' do
    it_validates 'foreign key of', :pha
    it_validates 'foreign key of', :onboarding_group
    it_validates 'foreign key of', :referral_code
    it_validates 'allows blank uniqueness of', :apns_token

    it 'validates member flag is true' do
      member.stub(:set_member_flag)
      expect(member).to be_valid
      member.member_flag = nil
      expect(member).to_not be_valid
    end

    context 'trial user' do
      let(:member) { build_stubbed(:member, :trial) }

      it 'validates presence of free_trial_ends_at' do
        expect(member).to be_valid
        member.free_trial_ends_at = nil
        expect(member).to_not be_valid
        expect(member.errors[:free_trial_ends_at]).to include("can't be blank")
      end
    end
  end

  describe 'callbacks' do
    describe '#notify_pha_of_new_member' do
      let(:member) { build(:member) }
      let(:pha) { build(:pha) }
      let(:delayed_new_member_task) { double('delayed new member task') }

      it 'creates a delayed NewMemberTask' do
        NewMemberTask.stub(delay: delayed_new_member_task)
        delayed_new_member_task.should_receive(:create!).once
        member.pha = pha
        expect(member.save).to be_true
      end

      context 'without a PHA' do
        it 'fires when PHA is added' do
          member.should_receive(:notify_pha_of_new_member).once
          member.pha = pha
          expect(member.save).to be_true
        end
      end

      context 'with a PHA' do
        let!(:pha) { create(:pha) }
        let!(:member) { create(:member, pha: pha) }
        let(:other_pha) { create(:pha) }

        it 'fires when the PHA is changed' do
          member.should_receive(:notify_pha_of_new_member).once
          member.pha = other_pha
          expect(member.save).to be_true
        end

        it 'does not fire when the PHA is not changed' do
          member.should_not_receive(:notify_pha_of_new_member)
          expect(member.save).to be_true
        end

        it 'does not fire when the PHA is removed' do
          member.should_not_receive(:notify_pha_of_new_member)
          member.pha = nil
          expect(member.save).to be_true
        end
      end
    end

    describe '#set_free_trial_ends_at' do
      let(:user) { create(:member, :invited) }
      let(:onboarding_group) { create(:onboarding_group, :premium, free_trial_days: 3) }

      it 'sets the free_trial_ends_at from onboarding_group on signed up' do
        user.update_attributes(onboarding_group: onboarding_group)
        expect(user.free_trial_ends_at).to be_nil
        user.update_attributes(password: 'password', status_event: :sign_up)
        expect(user.reload.free_trial_ends_at.to_i).to eq((Time.now.in_time_zone('Pacific Time (US & Canada)').end_of_day + 3.days).to_i)
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
    it 'returns true when member is in a signed up state' do
      expect(build_stubbed(:member, :free).signed_up?).to be_true
      expect(build_stubbed(:member, :trial).signed_up?).to be_true
      expect(build_stubbed(:member, :premium).signed_up?).to be_true
      expect(build_stubbed(:member, :chamath).signed_up?).to be_true
    end

    it 'returns false when member is not in a signed up state' do
      expect(build_stubbed(:member, :invited).signed_up?).to be_false
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

  describe '#alert_stakeholders_on_call_status' do
    let(:member) { build :member }

    context 'pha' do
      before do
        member.stub(:pha?) { true }
      end

      context 'on_call changed' do
        before do
          member.stub(:on_call_changed?) { true }
        end

        context 'phas are on call' do
          let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, work_phone_number: '1111111111'), build_stubbed(:pha_lead, work_phone_number: '4083913578')] }

          before do
            Role.stub_chain(:pha, :on_call?) { true }
          end

          context 'first pha came on call' do
            before do
              Role.stub_chain(:pha, :users) do
                o = Object.new
                o.stub(:where).with(on_call: true) do
                  o_o = Object.new
                  o_o.stub(:count) { 1 }
                  o_o
                end
                o
              end
              member.stub(:on_call?) { true }
            end

            it 'sends a message to each stakeholder' do
              Role.stub(:pha_stakeholders) { stakeholders }
              TwilioModule.should_receive(:message).with(
                nil,
                "OK: PHAs are triaging."
              )
              TwilioModule.should_receive(:message).with(
                '1111111111',
                "OK: PHAs are triaging."
              )
              TwilioModule.should_receive(:message).with(
                '4083913578',
                "OK: PHAs are triaging."
              )
              member.alert_stakeholders_on_call_status
            end
          end

          context 'second pha went off call' do
            before do
              Role.stub_chain(:pha, :users) do
                o = Object.new
                o.stub(:where).with(on_call: true) do
                  o_o = Object.new
                  o_o.stub(:count) { 1 }
                  o_o
                end
                o
              end
              member.stub(:on_call?) { false }
            end

            it 'does nothing' do
              TwilioModule.should_not_receive :message
              member.alert_stakeholders_on_call_status
            end
          end

          context 'another pha came on call' do
            before do
              Role.stub_chain(:pha, :users) do
                o = Object.new
                o.stub(:where).with(on_call: true) do
                  o_o = Object.new
                  o_o.stub(:count) { 3 }
                  o_o
                end
                o
              end
            end

            it 'does nothing' do
              TwilioModule.should_not_receive :message
              member.alert_stakeholders_on_call_status
            end
          end

          context 'last pha went off call' do
            before do
              Role.stub_chain(:pha, :users) do
                o = Object.new
                o.stub(:where).with(on_call: true) do
                  o_o = Object.new
                  o_o.stub(:count) { 0 }
                  o_o
                end
                o
              end
            end

            it 'sends a message to each stakeholder' do
              Role.stub(:pha_stakeholders) { stakeholders }
              TwilioModule.should_receive(:message).with(
                nil,
                "ALERT: No PHAs triaging!"
              )
              TwilioModule.should_receive(:message).with(
                '1111111111',
                "ALERT: No PHAs triaging!"
              )
              TwilioModule.should_receive(:message).with(
                '4083913578',
                "ALERT: No PHAs triaging!"
              )
              member.alert_stakeholders_on_call_status
            end
          end
        end

        context 'phas are not on call' do
          before do
            Role.stub_chain(:pha, :on_call?) { false }
          end

          it 'does nothing' do
            TwilioModule.should_not_receive :message
            member.alert_stakeholders_on_call_status
          end
        end
      end

      context 'on_call did not change' do
        before do
          member.stub(:on_call_changed?) { false }
        end

        it 'does nothing' do
          TwilioModule.should_not_receive :message
          member.alert_stakeholders_on_call_status
        end
      end
    end

    context 'not a pha' do
      before do
        member.stub(:pha?) { false }
      end

      it 'does nothing' do
        TwilioModule.should_not_receive :message
        member.alert_stakeholders_on_call_status
      end
    end
  end
end
