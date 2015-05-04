# Code values explained here (in case you ever need some light bedtime reading)
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/downloads/Data_Dissemination_File-Code_Values.pdf

class Search::Service::Bloom
  include HTTParty
  base_uri ENV['BLOOM_API_URL']

  def query(params)
    @zip_codes = params[:zip]
    response = self.class.get('/api/search', :query => query_params(params))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    local_addresses = Address.where(name: "Office").select{|address| @zip_codes.include? address.postal_code}
    local_providers = local_addresses.map{|address| address.user} if local_addresses
    sanitize_response(response.parsed_response).concat(format_local_providers(local_providers))
  end

  def find(params)
    response = self.class.get('/api/search', :query => query_params(:npi => params[:npi_number]))
    raise StandardError, 'Non-success response from NPI database' unless response.success?
    unless response['result'].count > 0
      raise ActiveRecord::RecordNotFound, "Could not find User with NPI number: #{params[:npi_number]}"
    end
    prepare_record(response['result'].first)
  end

  private

  QUERY_PARAMS = [:first_name, :last_name, :npi]

  def format_local_providers(providers)
    providers.map do |provider|
     {
       :first_name => provider.first_name,
       :last_name => provider.last_name,
       :address => format_address(provider, provider.addresses.find_by_name("Office")),
       :npi_number => provider.npi_number,
       :phone => provider.phone,
       :expertise => provider.expertise,
       :gender => provider.gender,
       :healthcare_taxonomy_code => 'hcp_code', # this line left in for backwards compabitility
       :provider_taxonomy_code => provider.provider_taxonomy_code,
       :taxonomy_classification => provider.taxonomy_classification
     }
    end
  end

  def format_address(provider,address)
    {
     address: address.address,
     address2: address.address2,
     city: address.city,
     state: address.state,
     postal_code: address.postal_code,
     country_code: nil,
     phone: provider.phone, # this line left in for backwards compatibility, deprecated since iOS build 1.0.4
     fax: nil,
     name: "NPI"
    }
  end

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
        result << query_string(counter, key, params['practice_address.zip'].split(' '))
      elsif key == 'offset' || key == 'limit'
        result << "#{key.to_s}=" + params[key].to_s.downcase
      elsif key == 'first_name' || key == 'last_name'
        params[key].split(/[\s\-']/).each do |partname|
          result << query_string(counter, key, partname)
          counter += 1
        end
      else
        result << query_string(counter, key, params[key])
      end
      counter += 1
    end
    result.join('&')
  end

  def query_string(number, key, values)
    values = [values] if values.is_a? String
    "key#{number}=#{key.to_s}&op#{number}=prefix" + values.map{|value| "&value#{number}=#{value.to_s.downcase}"}.join
  end

  def sanitize_response(response)
    @user_map = User.where(npi_number: response['result'].map{|record| record['npi'].to_s}).inject({}){|hash, user| hash[user.npi_number] = user; hash}

    response['result'].map do |record|
      prepare_record(record)
    end.compact
  end

  def prepare_record(record)
    @user_map ||= {}
    sanitized_record = sanitize_record(record)
    # override address when a provider has an office address in our database
    if u = @user_map[sanitized_record[:npi_number]]
      if a = u.addresses.find_by_name('office')
        sanitized_record[:address] = {
                                       address: a.address,
                                       city: a.city,
                                       state: a.state,
                                       postal_code: a.postal_code,
                                       name: a.name
                                     }
        if @zip_codes && !@zip_codes.include?(a.postal_code)
          sanitized_record = nil
        end
      end
    end
    # set avatar_url when a provider has one in our database
    sanitized_record[:avatar_url] = @user_map[record['npi'].to_s].avatar_url if @user_map[record['npi'].to_s].try(:avatar_url) if sanitized_record
    sanitized_record
  end

  def sanitize_record(record)
    p = record['practice_address']
    bloom_address = {
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
    sanitized_record = {
      :first_name => prettify(record['first_name']),
      :last_name => prettify(record['last_name']),
      :address => bloom_address,
      :npi_number => record['npi'].to_s,
      :phone => p['phone'],
      :expertise => record['credential'],
      :gender => record['gender'],
      :healthcare_taxonomy_code => hcp_code, # this line left in for backwards compabitility
      :provider_taxonomy_code => hcp_code,
      :taxonomy_classification => HCPTaxonomy.get_classification_by_hcp_code(hcp_code)
    }
    sanitized_record
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
