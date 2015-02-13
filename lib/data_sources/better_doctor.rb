class DataSources::BetterDoctor
  include HTTParty

  ## API Methods

  def self.lookup_by_npi(npi)
    wrap_api_call("doctors/npi/#{npi}") do |data|
      parse_doctor_response(data)
    end
  end

  def self.search(opts = default_search_opts)
    wrap_api_call("doctors?#{build_search_query(opts)}") do |data|
      data.map{|doctor_response| parse_doctor_response(doctor_response)}
    end
  end

  private

  ## TODO Store in config, environment, ??
  BETTER_DOCTOR_API = {
    api_key: "edd4c37c129961549d4f1882251b261c",
    base_url: "https://api.betterdoctor.com/",
    version: "beta"
    ## TODO Our key doesn't work for the "2015-01-27" version of the API
  }

  def self.build_query_url(arg_str)
    return if arg_str.empty?

    query_param_suffix = if arg_str =~ /\?/
                           "&"
                         else
                           "?"
                         end

    arg_str += query_param_suffix

    "#{BETTER_DOCTOR_API[:base_url]}#{BETTER_DOCTOR_API[:version]}/#{arg_str}user_key=#{BETTER_DOCTOR_API[:api_key]}"
  end

  ## TODO See API for payload fields - https://developer.betterdoctor.com/documentation
  def self.parse_doctor_response(doctor_response)
    { profile: doctor_response["profile"],
      ratings: doctor_response["ratings"].map{|r| r["rating"]},
      image_url: doctor_response["profile"]["image_url"]
    }
  end

  def self.default_search_opts
    { user_location: { lat: "37.773", lon: "-122.413" },
      distance: 10,
      query: "pediatrician",
      gender: "female"
      ## TODO More fields (specialty, insurance, etc) available - https://developer.betterdoctor.com/documentation
    }
  end

  ## TODO Extend if we want to search on more fields
  def self.build_search_query(opts)
    q = ""
    ## Params that can be included w/o transformation: https://developer.betterdoctor.com/documentation
    [:query, :gender].each do |k|
      if opts[k].present?
        q += "#{k}=#{opts[k]}&"
      end
    end

    ## Params that need to be formatted
    if opts[:user_location].present?
      loc = "#{opts[:user_location][:lat]},#{opts[:user_location][:lon]}"
      q += "user_location=#{loc}&"
      if opts[:distance].present?
        q += "location=#{loc},#{opts[:distance]}&"
      end
    end

    q.gsub(/&$/,'')
  end

  def self.wrap_api_call(query_str)
    response = HTTParty.get(build_query_url(query_str))

    if response.success?
      yield response["data"]
    else
      response_metadata = response["meta"]
      { error: response_metadata["message"], error_code: response_metadata["error_code"]}
    end
  end
end
