require 'spec_helper'

describe PhaProfile do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :user
  end

  describe '#max_capacity?' do
    context 'weekly_capacity is nil' do
      it 'returns false' do
        expect(build_stubbed(:pha_profile, weekly_capacity: nil).max_capacity?).to be_false
      end
    end

    context 'with weekly_capacity' do
      let!(:pha_profile) { create(:pha_profile) }
      let!(:member) { create(:member, :premium,
                             pha: pha_profile.user,
                             signed_up_at: Time.now.pacific.beginning_of_week + 1.minute) }

      context 'under capacity' do
        before do
          pha_profile.update_attributes(weekly_capacity: 2)
        end

        it 'returns false' do
          expect(pha_profile.max_capacity?).to be_false
        end
      end

      context 'at capacity' do
        before do
          pha_profile.update_attributes(weekly_capacity: 1)
        end

        it 'returns true' do
          expect(pha_profile.max_capacity?).to be_true
        end
      end

      context 'over capacity' do
        before do
          pha_profile.update_attributes(weekly_capacity: 0)
        end

        it 'returns true' do
          expect(pha_profile.max_capacity?).to be_true
        end
      end
    end
  end
end
