# Code values explained here (in case you ever need some light bedtime reading)
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/downloads/Data_Dissemination_File-Code_Values.pdf

class Search::Service::Bloom
  include HTTParty
  base_uri ENV['BLOOM_API_URL']

  def query(params)
    response = self.class.get('/api/search', :query => query_params(params))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    sanitize_response(response.parsed_response)
  end

  def find(params)
    response = self.class.get('/api/search', :query => query_params(:npi => params[:npi_number]))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    unless response['result'].count > 0
      raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}"
    end
    sanitize_record(response['result'].first)
  end

  private

  QUERY_PARAMS = [:first_name, :last_name, :npi]

  def sanitize_params(params)
    new_params = params.reject { |k, v| !QUERY_PARAMS.include?(k.to_sym) }
    new_params['practice_address.state'] = params[:state] if params[:state]
    new_params['practice_address.zip'] = params[:zip] if params[:zip]
    new_params['practice_address.city'] = params[:city] if params[:city]
    new_params['offset'] = params[:offset] if params[:offset]
    new_params['limit'] = params[:per] if params[:per]
    new_params
  end

  def query_params(params)
    params = sanitize_params(params)
    result = []
    counter = 0
    params.keys.each do |key|
      if key == 'practice_address.zip'
        result << "key#{counter}=practice_address.zip&op#{counter}=prefix" + params['practice_address.zip'].split(' ').map { |zip| "&value#{counter}=#{zip}" }.join
      elsif key == 'offset' || key == 'limit'
        result << "#{key.to_s}=" + params[key].to_s.downcase
      elsif key == 'first_name' || key == 'last_name'
        params[key].split(/[\s\-']/).each do |partname|
          result << "key#{counter}=#{key.to_s}&op#{counter}=prefix&value#{counter}=#{partname.to_s.downcase}"
          counter += 1
        end
      else
        result << "key#{counter}=#{key.to_s}&op#{counter}=prefix&value#{counter}=#{params[key].to_s.downcase}"
      end
      counter += 1
    end
    result.join('&')
  end

  def sanitize_response(response)
    response['result'].map do |record|
      sanitize_record(record)
    end
  end

  def sanitize_record(record)
    p = record['practice_address']
    practice_address = {
      address: prettify(p['address_line']),
      address2: prettify(p['address_details_line']),
      city: prettify(p['city']),
      state: p['state'],
      postal_code: p['zip'],
      country_code: p['county_code'],
      phone: p['phone'], # this line left in for backwards compatibility, deprecated since iOS build 1.0.4
      fax: p['fax'],
      name: "NPI"
    }

    hcp_code = get_hcp_code(record['provider_details'])
    santized_record = {
      :first_name => prettify(record['first_name']),
      :last_name => prettify(record['last_name']),
      :npi_number => record['npi'].to_s,
      :address => practice_address,
      :phone => p['phone'],
      :expertise => record['credential'],
      :gender => record['gender'],
      :healthcare_taxonomy_code => hcp_code, # this line left in for backwards compabitility
      :provider_taxonomy_code => hcp_code,
      :taxonomy_classification => HCPTaxonomy.get_classification_by_hcp_code(hcp_code)
    }
    avatar_url = User.find_by_npi_number(record['npi']).avatar_url if User.find_by_npi_number(record['npi'])
    santized_record[:avatar_url] = avatar_url if avatar_url
    santized_record
  end

  private

  def prettify(string)
    string.titleize(underscore: false, humanize: false) unless string.nil?
  end

  # Find the provider's Healthcare Provider Taxonomy Code.  There can only be one per NPI record
  def get_hcp_code(details_ary)
    if details_ary.size == 1
      details_ary.first['healthcare_taxonomy_code']
    else
      details_ary.each do |d|
        return d['healthcare_taxonomy_code'] if d['taxonomy_switch'] == 'yes'
      end

      # This code shouldn't be executed since a NPI record *should* have a taxonomy code.
      # Return last value, instead of nil, in case there's bad data.
      details_ary.last['healthcare_taxonomy_code']
    end
  end
end
