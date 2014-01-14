require 'spec_helper'

describe Agreement do
  it_has_a 'valid factory'
  it_validates 'presence of', :text
  it_validates 'inclusion of', :active

  context 'active' do
    let!(:current_agreement) { create(:agreement, :active) }
    let(:new_agreement) { build_stubbed(:agreement, :active) }

    it 'validates scoped uniqueness of active per type' do
      expect(new_agreement).to_not be_valid
      expect(new_agreement.errors[:active]).to include("has already been taken")
    end
  end

  describe '::active' do
    let!(:active) { create(:agreement, :active) }

    it 'returns the active record' do
      expect(described_class.active).to eq(active)
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
