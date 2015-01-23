require 'spec_helper'

describe Search::Service::Bloom do

  def npi
    @npi ||= Search::Service::Bloom.new
  end

  before :each do
    @params = {
        :last_name => 'yuan',
        :auth_token => '12345'
    }
  end

  describe '#sanitize_params' do
    before do
      @params[:state] = 'ca'
      @params[:city] = 'palo alto'
      @params[:zip] = '94301 94306'
    end
    it 'takes params and rehash the values' do
      @params[:zip] = '94301 94306'
      new_params = npi.send(:sanitize_params, @params)
      new_params['practice_address.zip'].should == '94301 94306'
      new_params['practice_address.city'].should == 'palo alto'
      new_params['practice_address.state'].should == 'ca'
      new_params['auth_token'].should == nil
    end
  end

  describe '#query_params' do
    context 'one query parameter' do
      it 'will return query string with last name as the sole parameter' do
        query = npi.send(:query_params, @params)
        query.should == 'key0=last_name&op0=prefix&value0=yuan'
      end
    end

    context 'more than one query parameter' do
      it 'will return string with multiple parameters' do
        @params[:state] = 'ca'
        query = npi.send(:query_params, @params)
        query.should == 'key0=last_name&op0=prefix&value0=yuan&key1=practice_address.state&op1=prefix&value1=ca'
      end
    end

    context 'more than one value for zip parameter' do
      it 'will set the value parameter in the url to multiple values' do
        @params[:zip] = '94301 94306'
        query = npi.send(:query_params, @params)
        query.should ==
            'key0=last_name&op0=prefix&value0=yuan&key1=practice_address.zip&op1=prefix&value1=94301&value1=94306'
      end
    end

    context 'no parameters' do
      it 'will return nothing' do
        @params.delete(:last_name)
        query = npi.send(:query_params, @params)
        query.should == ''
      end
    end
  end
end