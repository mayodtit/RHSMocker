class Numeric
  def to_rad
    self * PI / 180
  end
  def to_deg
    self * 180 / PI
  end
end


class Search::Service::Proximity
  def proximitySearch(params)
    # puts "Enter zipcode: "
    # in1 = gets.chomp

    # Find zip code in params
    zip = ""

    # puts "Enter Distance: "
    # in2 = gets.chomp
    # Find distance in params
    distance = ""

    # latN = (asin(sin(lat1.to_rad) * cos(dist/radius) + cos(lat1.to_rad) * sin(dist/radius) * cos(0.to_rad))).to_deg
    # latS = (asin(sin(lat1.to_rad) * cos(dist/radius) + cos(lat1.to_rad) * sin(dist/radius) * cos(180.to_rad))).to_deg
    # longE = (long1.to_rad + atan2(sin(90.to_rad) * sin(dist/radius) * cos(lat1.to_rad) , cos(dist/radius) - sin(lat1.to_rad) * sin(latN.to_rad))).to_deg
    # longW = (long1.to_rad + atan2(sin(270.to_rad) * sin(dist/radius) * cos(lat1.to_rad) , cos(dist/radius) - sin(lat1.to_rad) * sin(latN.to_rad))).to_deg
    # Calculate range of valid latitudes and longitudes

    # Arrays that hold index values of matches
    latFiltered = []
    index_bothFiltered = []

    # Iterate through data to filter appropriate values
    Proximity.find_each do |loc|
        if loc.latitude <=latN && loc.latittude>=latS
          latFiltered.push(loc)
        end

    end
    zipcode = s.column(2)
    city = s.column(3)
    state = s.column(4)
    county = s.column(6)
    latitude = s.column(10).map(&:to_f)
    longitude = s.column(11).map(&:to_f)



      # puts zipcode.find_index(in1)
      zc_index = zipcode.find_index(in1)
      lat1 = latitude[zc_index]
      long1 = longitude[zc_index]
      dist = in2.to_f
      radius = 3959




      # # puts latN
      # # puts latS
      # # puts longE
      # # puts longW
      #
      # f1 = latitude.each_with_index
      # f1 = f1.select { |lat, index| lat<=latN && lat>=latS }
      #
      # indexLat = f1.map {|item| item[1]}
      #
      # f2 = longitude.each_with_index
      # f2 = f2.select { |long, index| indexLat.include? index}
      #
      # # Get the list of longitudes filtered by latitude and apply longitude filter
      # f3 = (f2.map { |item| item[0] }).select { |long| long>=longW && long<=longE }
      #
      # # puts f1.length
      # # puts f3.length
      # # puts f3
      #
      # # Find the indexes again
      # f4 = f2.select { |long, index| f3.include? long}
      #
      # indexFiltered = f4.map { |long, index| index}
      #
      # indexFiltered.each {|index| puts zipcode[index], city[index], state[index] }
  end
end


