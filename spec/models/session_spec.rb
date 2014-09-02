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
    it_validates 'allows blank uniqueness of', :apns_token
    it_validates 'allows blank uniqueness of', :gcm_id
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

  describe '#store_apns_token!' do
    let!(:session) { create(:session) }
    let(:token) { 'test_token' }

    it 'saves the token' do
      session.store_apns_token!(token)
      expect(session.reload.apns_token).to eq(token)
    end

    context 'another session has the token' do
      let!(:other_session) { create(:session, apns_token: token) }

      it 'destroys the other session' do
        session.store_apns_token!(token)
        expect(session.reload.apns_token).to eq(token)
        expect(Session.find_by_id(other_session.id)).to be_nil
      end
    end
  end

  describe '#store_gcm_id!' do
    let!(:session) { create(:session) }
    let(:token) { 'test_token' }

    it 'saves the token' do
      session.store_gcm_id!(token)
      expect(session.reload.gcm_id).to eq(token)
    end

    context 'another session has the token' do
      let!(:other_session) { create(:session, gcm_id: token) }

      it 'destroys the other session' do
        session.store_gcm_id!(token)
        expect(session.reload.gcm_id).to eq(token)
        expect(Session.find_by_id(other_session.id)).to be_nil
      end
    end
  end
end
