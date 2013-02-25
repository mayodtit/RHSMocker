require 'factual'

class ResturantFinder
@@factual = Factual.new("0RUT6pzkePS5K03AY527SNwed0nEBcC9XRcx9S1C", "c1INovah7ZwyCohlu6JFuNeTbET68FCAh68leFSf")

#http://api.v3.factual.com/t/restaurants?filters={"cuisine":{"$search":"Italian"}}&geo={"$circle":{"$center":[39.938354,-75.157982],"$meters":5000}}

	def self.find()
		resturants = @@factual.table("restaurants-us").filters({"rating" => {"$gte" => 3}, "options_healthy" => true}).geo("$circle" => {"$center" => [37.446058, -122.167076], "$meters" => 5000}).rows

		puts resturants
	end

end