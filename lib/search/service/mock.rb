class Search::Service::Mock
  def query(params)
    [fake_data(params)]
  end

  def find(params)
    unless params[:npi_number]
      raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}"
    end
    fake_data(params)
  end

  private

  def fake_data(params)
    {
      first_name: params[:first_name] || 'John',
      last_name: params[:last_name] || 'Smith',
      npi_number: params[:npi_number] || rand(10 ** 10).to_s.rjust(10,'0'),
      city: 'Fake City',
      zip: '94301',
      state: params[:state] || 'CA',
      expertise: 'Internal Medicine'
    }
  end
end
