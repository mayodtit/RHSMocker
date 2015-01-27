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

  describe '#findNear' do
    context '3 mile distance' do
      it "should find params within the distance and return params with concatenated zip codes" do
        @params['dist'] = '3'
        @params['zip'] = '94301'
        createLocations({'city' => 'Palo Alto', 'zip' => '94301', 'latitude' => '37.4443', 'longitude' => '-122.15' })
        createLocations({'city' => 'Palo Alto', 'zip' => '94303', 'latitude' => '37.4673', 'longitude' => '-122.139' })
        createLocations({'city' => 'Sacramento', 'zip' => '94203', 'latitude' => '38.3805', 'longitude' => '-121.555' })
        new_params ||= proximity.findNear(@params)
        new_params['zip'].split.length.should == 2
        expect(new_params['zip'].split).to include '94301'
        expect(new_params['zip'].split).to include '94303'
      end
    end
  end

end