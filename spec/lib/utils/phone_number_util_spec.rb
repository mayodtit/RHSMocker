require './lib/utils/phone_number_util'

describe PhoneNumberUtil do
  describe '#prep_phone_number_for_db' do
    it 'returns nil if the input phone number is nil' do
      PhoneNumberUtil::prep_phone_number_for_db(nil).should be_nil
    end

    it 'removes all non-digit characters' do
      value = PhoneNumberUtil::prep_phone_number_for_db ' +   1  (408) 391 - 3578'
      value.should == '14083913578'
    end
  end
end