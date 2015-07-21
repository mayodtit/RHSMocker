require 'spec_helper'

describe CarePortalSession do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :queue_mode
  end

  describe '#default_queue_mode' do
    context 'if member is a nurse' do
      let!(:nurse) {create :nurse }
      let(:session) { build_stubbed :care_portal_session, member: nurse }

      it 'should return with nurse queue' do
        expect(session.default_queue_mode).to eq(:nurse)
      end
    end

    context 'if member has a past CarePortalSession' do
      let!(:specialist) {create :specialist}
      let!(:old_session) { create :care_portal_session, member: specialist}
      let(:session) { build_stubbed :care_portal_session, member: specialist }

      it 'should return with the old queue_mode' do
        expect(session.default_queue_mode).to eq(old_session.queue_mode)
      end
    end

    context 'if member is a specialist' do
      let!(:specialist) {create :specialist }
      let(:session) { build_stubbed :care_portal_session, member: specialist }

      it 'should return with specialist queue' do
        expect(session.default_queue_mode).to eq(:specialist)
      end
    end
  end

  describe '#set_defaults' do
    context 'on creating a care portal session' do
      before do
        CarePortalSession.stub(:default_queue_mode) { :hcc }
      end

      let!(:session) { create :care_portal_session}

      it 'should set the disabled_at' do
        expect(session.disabled_at).to_not be_nil
      end

      it 'should set the queue_mode' do
        expect(session.disabled_at).to_not be_nil
      end
    end
  end
end
