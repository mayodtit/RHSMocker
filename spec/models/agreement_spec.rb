require 'spec_helper'

describe Agreement do
  it_has_a 'valid factory'

  it_validates 'presence of', :text
  it_validates 'presence of', :type
  it_validates 'inclusion of', :active

  context 'active record' do
    let!(:current_agreement) { create(:agreement, :active) }
    let(:new_agreement) { build_stubbed(:agreement, :active) }

    it 'validates scoped uniqueness of active per type' do
      new_agreement.should_not be_valid
      new_agreement.errors[:active].should include("has already been taken")
    end
  end

  describe '::active' do
    let!(:active) { create(:agreement, :active) }
    let!(:inactive) { create(:agreement) }

    it 'returns only active records' do
      results = described_class.active
      results.should include(active)
      results.should_not include(inactive)
    end
  end

  describe '::current_for' do
    let!(:terms_of_service) { create(:agreement, :terms_of_service, :active) }
    let!(:privacy_policy) { create(:agreement, :privacy_policy, :active) }

    it 'returns active record for the type' do
      results = described_class.current_for(:terms_of_service)
      results.should == terms_of_service
      results.should_not == privacy_policy
    end
  end

  describe '#activate!' do
    let!(:old_agreement) { create(:agreement, :active) }
    let!(:new_agreement) { create(:agreement) }

    it 'unsets active for other records' do
      expect{ new_agreement.activate! }.to change{ old_agreement.reload.active? }.from(true).to(false)
    end

    it 'sets the current record as active' do
      expect{ new_agreement.activate! }.to change{ new_agreement.reload.active? }.from(false).to(true)
    end

    it 'does not change an active record' do
      expect{ old_agreement.activate! }.to_not change{ old_agreement.reload.active? }
    end
  end
end
