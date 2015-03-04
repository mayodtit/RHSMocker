class Search::Service
  def query(params, services=nil)
    npi.query(params)
  end

  def find(params, services=nil)
    npi.find(params)
  end

  def snomed_query(params, services=nil)
    snomed.query(params)
  end

  def proximity(params, services=nil)
    @geo ||= Search::Geo::Proximity.new
    @geo.find_near(params)
  end

  private

  def npi
    @npi ||= Search::Service::Bloom.new
  end

  def snomed
    @snomed ||= Search::Service::Snomed.new
  end
end

