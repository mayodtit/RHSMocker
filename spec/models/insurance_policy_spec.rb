require 'spec_helper'

describe InsurancePolicy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user

  describe 'callbacks' do
    describe '#create_tasks' do
      let!(:service_type) { create(:service_type, name: 'process insurance card') }
      let!(:pha) { create(:pha) }
      let!(:member) { create(:member, :premium, pha: pha) }

      it 'creates a MemberTask after create' do
        expect{ described_class.create(user: member, actor: member) }.to change(MemberTask, :count).by(1)
        expect(MemberTask.last.service_type).to eq(service_type)
      end

      it 'creates a InsurancePolicyTask after create' do
        expect{ described_class.create(user: member, actor: member) }.to change(InsurancePolicyTask, :count).by(1)
      end
    end
  end
end
