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
  def findNear(params)
    begin
    # Find query zip code in params
    qzip = params["zip"]

    # Find query distance in params
    qdist = params["dist"]

    # Find object with query zip code in geo data
    qloc = Proximity.find(:first, :conditions => { :zip => qzip})
    qlat = qloc.latitude
    qlong = qloc.longitude

    # Set other parameters
    dist = qdist.to_f
    radius = 3959

    latN = (asin(sin(qlat.to_rad) * cos(dist/radius) + cos(qlat.to_rad) * sin(dist/radius) * cos(0.to_rad))).to_deg
    latS = (asin(sin(qlat.to_rad) * cos(dist/radius) + cos(qlat.to_rad) * sin(dist/radius) * cos(180.to_rad))).to_deg
    longE = (qlong.to_rad + atan2(sin(90.to_rad) * sin(dist/radius) * cos(qlat.to_rad) , cos(dist/radius) - sin(qlat.to_rad) * sin(latN.to_rad))).to_deg
    longW = (qlong.to_rad + atan2(sin(270.to_rad) * sin(dist/radius) * cos(qlat.to_rad) , cos(dist/radius) - sin(qlat.to_rad) * sin(latN.to_rad))).to_deg
    # Calculate range of valid latitudes and longitudes

    # Arrays that hold matches
    bothFiltered = []

    # Iterate through data to filter appropriate values
    Proximity.where('latitude >= ? AND latitude <= ?', latS, latN).each do |loc|
      if loc.longitude>=longW && loc.longitude<=longE
        bothFiltered.push(loc)
      end
    end

    zipString = ""
    bothFiltered.each do |loc|
      zipString = zipString + " " + loc.zip.to_s
    end

    params["zip"] = zipString

    return params

    rescue
      puts "Error in geo/proximity.rb"
    end
  end
end


