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
    it_validates 'foreign key of', :nux_answer

    it 'validates member flag is true' do
      member.stub(:set_member_flag)
      expect(member).to be_valid
      member.member_flag = nil
      expect(member).to_not be_valid
    end

    it 'validates emaiL_confirmation_token is present' do
      member.stub(:set_email_confirmation_token)
      expect(member).to be_valid
      member.email_confirmed = false
      member.email_confirmation_token = nil
      expect(member).to_not be_valid
    end

    context 'signed_up user' do
      before do
        member.stub(:set_signed_up_at)
        member.safe_stub(:signed_up?).and_return(true)
      end

      it 'validates presence of signed_up_at' do
        member.signed_up_at = nil
        expect(member).to_not be_valid
        expect(member.errors[:signed_up_at]).to include("can't be blank")
      end
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

    describe '#unset_free_trial_ends_at' do
      let(:trial_member) { create(:member, :trial) }
      let(:premium_member) { build_stubbed(:member, :premium) }

      it 'unsets free_trial_ends_at for non-trial members' do
        premium_member.free_trial_ends_at = Time.now + 1.day
        premium_member.valid?
        expect(premium_member.free_trial_ends_at).to be_nil
      end

      it 'unsets free_trial_ends_at when a trial member is upgraded' do
        expect(trial_member.free_trial_ends_at).to_not be_nil
        trial_member.upgrade!
        expect(trial_member.free_trial_ends_at).to be_nil
      end
    end

    describe 'set_invitation_token' do
      let(:member) { create(:member, :invited) }

      it 'sets the invitation token before validation for an invited member' do
        member.invitation_token = nil
        member.valid?
        expect(member.invitation_token).to_not be_nil
      end

      it 'does not set the same invitation token multiple times' do
        Base64.stub(:urlsafe_encode64).and_return('baadbeef', 'baadbeef', 'baadbeef', 'deadbeef')
        member.invitation_token = nil
        member.save!
        expect(member.invitation_token).to eq('baadbeef')
        member2 = create(:member, :invited)
        member2.invitation_token = nil
        member2.save!
        expect(member2.invitation_token).to eq('deadbeef')
      end
    end

    describe 'unset_invitation_token' do
      let(:invited_member) { create(:member, :invited) }
      let(:trial_member) { build_stubbed(:member, :trial) }

      it 'unsets invitation_token for non-invited members' do
        trial_member.invitation_token = 'hello'
        trial_member.valid?
        expect(trial_member.invitation_token).to be_nil
      end

      it 'unsets invitation_token for when a member claims their invitation' do
        expect(invited_member.invitation_token).to_not be_nil
        invited_member.sign_up!
        expect(invited_member.invitation_token).to be_nil
      end
    end

    describe '#add_onboarding_group_cards' do
      let!(:onboarding_group_card) { create(:onboarding_group_card) }
      let(:onboarding_group) { onboarding_group_card.onboarding_group }
      let(:resource) { onboarding_group_card.resource }
      let!(:member) { create(:member, onboarding_group: onboarding_group) }

      it 'adds cards to the new member' do
        expect(member.cards.where(resource_id: resource.id, resource_type: resource.class.name).count).to eq(1)
      end
    end

    describe '#add_onboarding_group_programs' do
      let!(:onboarding_group_program) { create(:onboarding_group_program) }
      let(:onboarding_group) { onboarding_group_program.onboarding_group }
      let(:program) { onboarding_group_program.program }
      let!(:member) { create(:member, onboarding_group: onboarding_group) }

      it 'adds programs to the new member' do
        expect(member.programs.where(programs: {id: program.id}).count).to eq(1)
      end
    end

    describe '#update_referring_scheduled_communications' do
      let!(:member) { create(:member, :trial) }

      it 'is only called when free_trial_ends_at is changed' do
        member.should_not_receive(:update_referring_scheduled_communications)
        member.save!
      end

      context 'when free_trial_ends_at changes' do
        let!(:scheduled_communication) { create(:scheduled_communication, :with_reference, reference: member) }

        context 'free_trial_ends_at is nil' do
          it 'destroys all referring scheduled communications' do
            expect(member.reload.update_attributes(status_event: :upgrade, free_trial_ends_at: nil)).to be_true
            expect(ScheduledCommunication.find_by_id(scheduled_communication.id)).to be_nil
          end
        end

        context 'free_trial_ends_at is present' do
          it 'calls update_publish_at_from_calculation! on all referring scheduled communications' do
            publish_at = scheduled_communication.publish_at
            expect(member.update_attributes(free_trial_ends_at: Time.now + 5.days)).to be_true
            expect(scheduled_communication.reload.publish_at).to_not eq(publish_at)
          end
        end
      end
    end

    describe '#notify_pha_of_upgrade' do
      context 'when user signed up as a trial member' do
        let!(:member) { create(:member, :trial) }
        it 'creates an UpgradeTask for PHAs' do
          expect{ member.upgrade! }.to change(UpgradeTask, :count).by(1)
        end
      end

      context 'when user signed up as premium member' do
        it 'should not create UpgradeTask when member signs up with credit card as premium member' do
          expect{ Member.create(status: 'premium') }.to change(UpgradeTask, :count).by(0)
        end
        it 'should not create UpgradeTask when member signs up with credit card as chamath member' do
          expect{ Member.create(status: 'chamath') }.to change(UpgradeTask, :count).by(0)
        end
      end
    end
  end

  describe 'scopes' do
    describe '::with_request_or_service_task' do
      let!(:engagement_service_type) { create(:service_type, bucket: 'engagement') }
      let!(:other_service_type) { create(:service_type, bucket: 'other') }

      let!(:with_member_task) { create(:member_task, service_type: engagement_service_type).member }
      let!(:with_request_task) { create(:user_request).user }
      let!(:with_service_task) { create(:member_task, service_type: other_service_type).member }

      it 'returns members with a request or service task' do
        result = described_class.with_request_or_service_task
        expect(result).to include(with_request_task, with_service_task)
        expect(result).to_not include(with_member_task)
      end
    end
  end

  describe 'states' do
    describe 'invited' do
      let(:member) { build_stubbed(:member, :invited) }

      it 'validates presence of invitation_token' do
        member.stub(:set_invitation_token)
        expect(member).to be_valid
        member.invitation_token = nil
        expect(member).to_not be_valid
        expect(member.errors[:invitation_token]).to include("can't be blank")
      end
    end

    describe 'free' do
      let(:member) { build_stubbed(:member, :free) }

      it 'validates free_trial_ends_at_is_nil' do
        member.stub(:unset_free_trial_ends_at)
        expect(member).to be_valid
        member.free_trial_ends_at = Time.now + 1.day
        expect(member).to_not be_valid
        expect(member.errors[:free_trial_ends_at]).to include("must be nil")
      end
    end

    describe 'trial' do
      let(:member) { build_stubbed(:member, :trial) }

      it 'validates presence of free_trial_ends_at' do
        expect(member).to be_valid
        member.free_trial_ends_at = nil
        expect(member).to_not be_valid
        expect(member.errors[:free_trial_ends_at]).to include("can't be blank")
      end
    end

    describe 'premium' do
      let(:member) { build_stubbed(:member, :premium) }

      it 'validates free_trial_ends_at_is_nil' do
        member.stub(:unset_free_trial_ends_at)
        expect(member).to be_valid
        member.free_trial_ends_at = Time.now + 1.day
        expect(member).to_not be_valid
        expect(member.errors[:free_trial_ends_at]).to include("must be nil")
      end
    end

    describe 'chamath' do
      let(:member) { build_stubbed(:member, :chamath) }

      it 'validates free_trial_ends_at_is_nil' do
        member.stub(:unset_free_trial_ends_at)
        expect(member).to be_valid
        member.free_trial_ends_at = Time.now + 1.day
        expect(member).to_not be_valid
        expect(member.errors[:free_trial_ends_at]).to include("must be nil")
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

  describe '::phas' do
    let!(:pha) { create(:pha) }

    it 'returns all PHAs using Roles' do
      expect(described_class.phas).to include(pha)
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

  describe '#confirm_email!' do
    let(:member) { create(:member, email_confirmed: false, email_confirmation_token: 'token') }

    it 'sets email confirmed and removes the email confirmation token' do
      member.confirm_email!
      expect(member.reload.email_confirmed?).to be_true
      expect(member.email_confirmation_token).to be_nil
    end
  end

  describe '#smackdown!' do
    let(:member) { build :member }
    let(:consult) { build :consult }
    let(:message_template) { build :message_template }

    before do
      MessageTemplate.stub(:find_by_name).with('TOS Violation') { message_template }
      message_template.stub :create_message
      member.stub(:master_consult) { consult }
      member.stub :downgrade!
    end

    it 'downgrades the user' do
      member.should_receive :downgrade!
      member.smackdown!
    end

    it 'creates the user' do
      message_template.should_receive(:create_message).with(Member.robot, consult, false, true, true)
      member.smackdown!
    end
  end
end
