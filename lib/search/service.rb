class Search::Service
  def query(params, services=nil)
    npi.query(params)
  end

  def find(params, services=nil)
    npi.find(params)
  end

  private

  def npi
    @npi ||= Search::Service::Mock.new
  end
end
