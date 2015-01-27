require 'spec_helper'

describe Search::Geo::Proximity do
  def proximity
    @proximity ||= Search::Geo::Proximity.new
  end

  def createLocations(params)
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

  describe '#checkParams' do
    context 'valid params' do
      it 'should return true' do
        @params['dist'] = '3'
        @params['zip'] = '94301'
        valid = proximity.checkParams(@params)

        expect(valid).to eq(true)
      end
    end

    context 'both invalid params' do
      it 'should return true' do
        valid = proximity.checkParams(@params)

        expect(valid).to eq(false)
      end
    end

    context 'one invalid params' do
      it 'should return true' do
        @params['dist'] = '3'
        valid = proximity.checkParams(@params)

        expect(valid).to eq(false)

        @params.delete 'dist'
        @params['zip'] = '94301'
        valid = proximity.checkParams(@params)

        expect(valid).to eq(false)
      end
    end
  end

  describe '#findNear' do
    context 'valid params' do
      it "should return 94301 and 94303 and not 94203" do
        @params['dist'] = '3'
        @params['zip'] = '94301'
        createLocations({'city' => 'Palo Alto', 'zip' => '94301', 'latitude' => '37.4443', 'longitude' => '-122.15' })
        createLocations({'city' => 'Palo Alto', 'zip' => '94303', 'latitude' => '37.4673', 'longitude' => '-122.139' })
        createLocations({'city' => 'Sacramento', 'zip' => '94203', 'latitude' => '38.3805', 'longitude' => '-121.555' })
        new_params ||= proximity.findNear(@params)
        zipString = new_params['zip'].split

        zipString.length.should == 2
        zipString.should_not include '94203'
        expect(zipString).to include '94301'
        expect(zipString).to include '94303'
      end
    end

    context 'invalid params, values missing' do
      it "should return original params" do
        new_params ||= proximity.findNear(@params)

        new_params.should eq(@params)
      end
    end

    context 'invalid params, one value missing' do
      it "should return original params" do
        @params['dist'] = '3'
        new_params ||= proximity.findNear(@params)

        new_params.should eq(@params)

        @params.delete 'dist'
        @params['zip'] = '94301'
        new_params ||= proximity.findNear(@params)
        
        new_params.should eq(@params)
      end
    end
  end

end