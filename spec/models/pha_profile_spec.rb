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
    it_validates 'numericality of', :capacity_weight
    it_validates 'integer numericality of', :capacity_weight
    it_validates 'inclusion of', :silence_low_welcome_call_email
  end

  describe '::with_capcity' do
    let!(:pha_profile_with_capacity) { create(:pha_profile) }
    let!(:pha_profile_without_capacity) { create(:pha_profile) }

    before do
      described_class.stub(all: [pha_profile_with_capacity, pha_profile_without_capacity])
      pha_profile_with_capacity.stub(max_capacity?: false)
      pha_profile_without_capacity.stub(max_capacity?: true)
    end

    it 'returns only PHAs with weekly capacity' do
      with_capacity = described_class.with_capacity
      expect(with_capacity).to include(pha_profile_with_capacity)
      expect(with_capacity).to_not include(pha_profile_without_capacity)
    end
  end

  describe '::next_pha_profile' do
    let!(:pha_profile) { create(:pha_profile) }
    let!(:other_pha_profile) { create(:pha_profile) }

    it 'returns the first profile if we "randomly" select them' do
      Random.stub(rand: 0)
      expect(described_class.next_pha_profile).to eq(pha_profile)
    end

    it 'returns the second profile if we "randomly" select that one' do
      Random.stub(rand: 100)
      expect(described_class.next_pha_profile).to eq(other_pha_profile)
    end

    it 'returns nil if there are no pha profiles' do
      described_class.stub(with_capacity: [])
      expect(described_class.next_pha_profile).to eq(nil)
    end

    describe 'PHA with capacity 0' do
      let!(:final_pha_profile) { create(:pha_profile, capacity_weight: 0) }

      it 'returns the second profile not the third' do
        Random.stub(rand: 100)
        expect(described_class.next_pha_profile).to eq(other_pha_profile)
      end
    end

    context 'mayo_pilot' do
      let!(:mayo_pha_profile) { create(:pha_profile, mayo_pilot_capacity_weight: 100) }

      it 'returns a pha_profile of a pha with mayo_pilot set' do
        expect(described_class.next_pha_profile(true)).to eq(mayo_pha_profile)
      end
    end
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
