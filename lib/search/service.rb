class Search::Service
  def query(params, services=nil)
    npi.query(params)
  end

  def find(params, services=nil)
    npi.find(params)
  end

  def proximity(params, services=nil)
    if !params['dist'].nil? && !params['zip'].nil?
      @geo||= Search::Geo::Proximity.new
      @geo.findNear(params)
    end
  end

  private

  def npi
    @npi ||= Search::Service::Bloom.new
  end
end
