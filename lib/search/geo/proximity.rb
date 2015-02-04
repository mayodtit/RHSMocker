include Math

class Numeric
  def to_rad
    self * PI / 180
  end
  def to_deg
    self * 180 / PI
  end
end

class Search::Geo::Proximity
  #radius in miles
  EARTH_RADIUS = 3959.0

  def find_near(params)
    return params unless valid_params?(params)
    query = extract_params(params)
    query = query.merge(latitude_range(query))
    query = query.merge(longitude_range(query))
    calculate_zips(params, query)
  end

  def valid_params?(params)
    !params['dist'].nil? && !params['zip'].nil?
end

  def extract_params(params)
    zip = params['zip']
    location = Proximity.where(zip: zip)[0]
    {'dist'=> params['dist'].to_f, 'lat' => location.latitude.to_f, 'long' => location.longitude.to_f}
  end

  def latitude_range(query)
    lat = query['lat']
    dist = query['dist']

    range = {
        #North boundary
        'latN' => (asin(sin(lat.to_rad) * cos(dist/EARTH_RADIUS) + cos(lat.to_rad) * sin(dist/EARTH_RADIUS) *
                         cos(0.to_rad))).to_deg,
        #South boundary
        'latS' => (asin(sin(lat.to_rad) * cos(dist/EARTH_RADIUS) + cos(lat.to_rad) * sin(dist/EARTH_RADIUS) *
                         cos(180.to_rad))).to_deg
    }
  end

  def longitude_range(query)
    long = query['long']
    lat = query['lat']
    dist = query['dist']
    latN = query['latN']

    range = {
        'longE' => (long.to_rad + atan2(sin(90.to_rad) * sin(dist/EARTH_RADIUS) *cos(lat.to_rad) ,
                             cos(dist/EARTH_RADIUS) - sin(lat.to_rad) * sin(latN.to_rad))).to_deg,
        'longW' => (long.to_rad + atan2(sin(270.to_rad) * sin(dist/EARTH_RADIUS) * cos(lat.to_rad) ,
                             cos(dist/EARTH_RADIUS) - sin(lat.to_rad) * sin(latN.to_rad))).to_deg
    }
  end

  def calculate_zips(params, query)
    latN = query['latN']
    latS = query['latS']
    longW = query['longW']
    longE = query['longE']

    params["zip"] = Proximity.where('latitude >= ? AND latitude <= ? AND longitude >= ? AND longitude <= ?',
                    latS, latN, longW, longE).pluck(:zip).join(' ')
    params
  end
end



