require 'spec_helper'

describe SuggestedServiceChange do
  it_has_a 'valid factory'
  it_validates 'presence of', :suggested_service

  describe 'actor validations' do
    let(:suggested_service_change) { create(:suggested_service_change) }

    it 'validates presence when data is present' do
      expect(suggested_service_change).to be_valid
      suggested_service_change.data = {test: :data}
      expect(suggested_service_change).to_not be_valid
      expect(suggested_service_change.errors[:actor]).to include("can't be blank")
    end

    it 'validates presence for certain events' do
      expect(suggested_service_change).to be_valid
      suggested_service_change.event = 'offer'
      expect(suggested_service_change).to_not be_valid
      expect(suggested_service_change.errors[:actor]).to include("can't be blank")
      suggested_service_change.event = 'accept'
      expect(suggested_service_change).to_not be_valid
      expect(suggested_service_change.errors[:actor]).to include("can't be blank")
      suggested_service_change.event = 'reject'
      expect(suggested_service_change).to_not be_valid
      expect(suggested_service_change.errors[:actor]).to include("can't be blank")
    end
  end
end
