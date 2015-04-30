require 'spec_helper'

describe PhoneNumberUtil do
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
