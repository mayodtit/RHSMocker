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

  describe "#query" do
    let!(:params){{:zip =>"27514", :dist =>1}}

    def do_request
      Search::Service::Bloom.new.query(params)
    end

    context "there are local records matching the search criteria" do
      let(:user){create(:user, first_name: "bloom_test 1")}
      let!(:address){create(:address, name: "Office", postal_code: "27514", user: user)}

      before do
        stub_request(:any, /warrior.getbetter.com/).to_rack(FakeBloom)
      end

      it "should include the local record to the result" do
        expect(do_request.last[:first_name]).to eq(user.first_name)
      end
    end

    context "there are local records matching the returned provider with unmatching address" do
      let!(:user){create(:user, first_name: "bloom test 2",  npi_number: "1417983420")}
      let!(:address){create(:address, name: "Office", postal_code: "94301", user: user)}

      before do
        stub_request(:any, /warrior.getbetter.com/).to_rack(FakeBloom)
      end

      it "should exclude the address from the returned result" do
        do_request.each do |record|
          expect(record[:npi_number]).not_to eq(user.npi_number)
        end
      end
    end
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

  describe '#sanitize_record' do
    it 'will take record and rehash it' do
      record = {
          'business_address' => {
              'address_line' => '1906 PINE MEADOW DR',
              'city' => 'SANTA ROSA',
              'country_code' => 'US',
              'state' => 'CA',
              'zip' => '954031584'
          },
          'credential' => 'PHARM.D.',
          'enumeration_date' => '2012-07-17T00:00:00.000Z',
          'first_name' => 'BENJAMIN',
          'gender' => 'male',
          'last_name' => 'WANG',
          'last_update_date' => '2012-07-17T00:00:00.000Z',
          'middle_name' => 'SHIAN EN',
          'name_prefix' => 'DR.',
          'npi' => '1457606311',
          'practice_address' => {
              'address_line' => '3801 MIRANDA AVE',
              'city' => 'PALO ALTO',
              'country_code' => 'US',
              'phone' => '6504935000',
              'state' => 'CA',
              'zip' => '943041207'
          },
          'provider_details' => [{
                                     'healthcare_taxonomy_code' => '183500000X',
                                     'license_number' => '67223',
                                     'license_number_state' => 'CA',
                                     'taxonomy_switch' => 'yes'
                                 }],
          'sole_proprietor' => 'no',
          'type' => 'individual'
      }
      new_record = npi.send(:sanitize_record, record)
      new_record[:first_name].should == 'Benjamin'
      new_record[:last_name].should == 'Wang'
      new_record[:npi_number].should == '1457606311'
      new_record[:address][:address].should == '3801 Miranda Ave'
      new_record[:address][:state].should == 'CA'
      new_record[:address][:postal_code].should == '943041207'
      new_record[:address][:name].should == 'NPI'
      new_record[:phone].should == '6504935000'
    end
  end

  describe '#prettify' do
    context 'not nil string' do
      it 'titleizes the string' do
        pretty_string = npi.send(:prettify, 'PALO ALTO')
        pretty_string.should == 'Palo Alto'
      end
    end
    context 'null string' do
      it 'returns nil for nil string' do
        pretty_string = npi.send(:prettify, nil)
        pretty_string.should == nil
      end
    end
  end
end
