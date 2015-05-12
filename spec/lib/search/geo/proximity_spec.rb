require 'spec_helper'

describe Search::Geo::Proximity do
  def proximity
    @proximity ||= Search::Geo::Proximity.new
  end

  def create_locations(params)
    Proximity.create!(
                 :city => params['city'],
                 :zip => params['zip'],
                 :state=> params['state'],
                 :county => params['county'],
                 :latitude => params['latitude'],
                :longitude => params['longitude']
    )
  end

  before :each do
    @params = {
        :last_name => 'ma',
        :auth_token => '12345',
    }
  end

  describe '#valid_params' do
    context 'valid params' do
      before do
        @params['dist'] = '3'
        @params['zip'] = '94301'
      end

      it 'should return true' do
        expect(proximity.valid_params?(@params)).to eq(true)
      end
    end
  end

  describe '#find_near' do
    context 'valid params' do
      it "should return 94301 and 94303 and not 94203" do
        @params['dist'] = '3'
        @params['zip'] = '94301'
        create_locations({'city' => 'Palo Alto', 'zip' => '94301', 'latitude' => '37.4443', 'longitude' => '-122.15' })
        create_locations({'city' => 'Palo Alto', 'zip' => '94303', 'latitude' => '37.4673', 'longitude' => '-122.139' })
        create_locations({'city' => 'Sacramento', 'zip' => '94203', 'latitude' => '38.3805', 'longitude' => '-121.555' })
        new_params ||= proximity.find_near(@params)
        
        zips = new_params['zip'].split

        zips.length.should == 2
        zips.should_not include '94203'
        expect(zips).to include '94301'
        expect(zips).to include '94303'
      end
    end

    context 'invalid params, values missing' do
      it "should return original params" do
        new_params ||= proximity.find_near(@params)

        new_params.should eq(@params)
      end
    end

    context 'invalid params, one value missing' do
      it "should return original params" do
        @params['dist'] = '3'
        new_params ||= proximity.find_near(@params)

        new_params.should eq(@params)

        @params.delete 'dist'
        @params['zip'] = '94301'
        new_params ||= proximity.find_near(@params)
        
        new_params.should eq(@params)
      end
    end
  end

end