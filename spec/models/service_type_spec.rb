require 'spec_helper'

describe ServiceType do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :bucket

    context '#bucket' do
      it 'is valid if in BUCKETS' do
        service_type = build :service_type, bucket: 'poo'
        service_type.should_not be_valid
      end

      it 'is not valid if not in BUCKETS' do
        service_type = build :service_type, bucket: ServiceType::BUCKETS[0]
        service_type.should be_valid
      end
    end
  end
end
