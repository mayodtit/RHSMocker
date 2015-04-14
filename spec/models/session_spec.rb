require 'spec_helper'

describe Session do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_auth_token)
    end

    it_validates 'presence of', :member
    it_validates 'presence of', :auth_token
    it_validates 'uniqueness of', :auth_token
  end

  describe 'database constraints' do
    it 'validates uniqueness of auth_token' do
      session1 = create(:session, auth_token: 'test_token')
      session2 = build(:session, auth_token: session1.auth_token)
      expect{ session2.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe '#set_auth_token' do
    let(:session) { build_stubbed(:session) }

    it 'sets the auth_token before validation' do
      session.auth_token = nil
      session.valid?
      expect(session.auth_token).to_not be_nil
    end

    context 'with an existing session' do
      let!(:session) { create(:session, auth_token: 'baadbeef') }

      it 'does not set the same auth_token multiple times' do
        Base64.stub(:urlsafe_encode64).and_return('baadbeef', 'baadbeef', 'baadbeef', 'deadbeef')
        new_session = build(:session, auth_token: nil)
        new_session.save!
        expect(new_session.auth_token).to eq('deadbeef')
      end
    end
  end

  describe '#set_disabled_at' do
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'member is a pha' do
      let!(:pha) {create :pha}

      context 'member is logging in from care portal' do
        let!(:pha_cp_session) { create :session, member: pha, device_os: nil }

        it 'sets disabled_at to 15 minutes from now' do
          expect(pha_cp_session.disabled_at).to eq 15.minutes.from_now
        end
      end

      context 'member is logging in from mobile device' do
        let!(:pha_mobile_session) { create :session, member: pha, device_os: 'iOS' }

        it 'should not set disabled_at' do
          expect(pha_mobile_session.disabled_at).to be_nil
        end
      end
    end

    context 'member is not a pha' do
      let(:member) { build_stubbed :member }
      let!(:member_session) { create :session, member: member }

      it 'should not set disabled_at' do
        expect(member_session.disabled_at).to be_nil
      end
    end
  end
end
