require 'spec_helper'

describe ProviderProfile do
  describe 'validations' do
    describe 'npi_number' do
      it 'should be nil or exactly 10 characters' do
        FactoryGirl.build(:provider_profile, npi_number: nil).should be_valid
        FactoryGirl.build(:provider_profile, npi_number: 1234567890).should be_valid
        FactoryGirl.build(:provider_profile, npi_number: 1).should_not be_valid
      end

      it 'should be unique across all providers, if present' do
        FactoryGirl.create(:provider_profile, npi_number: 1234567890)
        FactoryGirl.build(:provider_profile, npi_number: 1234567890).should_not be_valid
        FactoryGirl.create(:provider_profile, npi_number: nil)
        FactoryGirl.build(:provider_profile, npi_number: nil).should be_valid
      end
    end

    describe 'taxonomy_code' do
      it 'should be nil or exactly 10 characetrs' do
        FactoryGirl.build(:provider_profile, taxonomy_code: nil).should be_valid
        FactoryGirl.build(:provider_profile, taxonomy_code: 'abcdefghij').should be_valid
        FactoryGirl.build(:provider_profile, taxonomy_code: 'a').should_not be_valid
      end
    end
  end
end
