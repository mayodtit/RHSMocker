require 'spec_helper'

describe PhoneNumberUtil do
  describe '#prep_phone_number_for_db' do
    it 'returns nil if the input phone number is nil' do
      PhoneNumberUtil::prep_phone_number_for_db(nil).should be_nil
    end

    it 'removes all non-digit characters' do
      value = PhoneNumberUtil::prep_phone_number_for_db '(408) 391 - 3578'
      value.should == '4083913578'
    end

    it 'removes country code from 11 digit numbers' do
      value = PhoneNumberUtil::prep_phone_number_for_db '14083913578'
      value.should == '4083913578'
    end

    it 'it removes + characters' do
      value = PhoneNumberUtil::prep_phone_number_for_db '+14083913578'
      value.should == '4083913578'
    end
  end

  # describe '#is_valid_caller_id' do
  #   it 'returns false if it is a number that indicates the ID is RESTRICTED' do
  #     PhoneNumberUtil::is_valid_caller_id('7378742833').should be_false
  #   end

  #   it 'returns false if it is a number that indicates the ID is BLOCKED' do
  #     PhoneNumberUtil::is_valid_caller_id('2562533').should be_false
  #   end

  #   it 'returns false if it is a number that indicates the ID is UNKNOWN' do
  #     PhoneNumberUtil::is_valid_caller_id('8656696').should be_false
  #   end

  #   it 'returns false if it is a number that indicates the ID is ANONYMOUS' do
  #     PhoneNumberUtil::is_valid_caller_id('266696687').should be_false
  #   end

  #   it 'returns true for valid numbers' do
  #     PhoneNumberUtil::is_valid_caller_id('4083913578').should be_true
  #   end
  # end

  describe '#format_for_dialing' do
    it 'returns nil if the input phone number is nil' do
      PhoneNumberUtil::format_for_dialing(nil).should be_nil
    end

    it 'it adds a + and 1 at the end of a number' do
      PhoneNumberUtil.format_for_dialing('4083913578').should == '+14083913578'
    end

    it 'only adds a + when it already ends with 1' do
      PhoneNumberUtil.format_for_dialing('14083913578').should == '+14083913578'
    end
  end
end
