require 'httparty'

class DataSources::BetterDoctor
  ## API Methods

  ## TODO NEXT refactor this so it can be tested without making the request
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

  def self.specialties
    @specialties ||= wrap_api_call("specialties") do |data|
      data ## see https://developer.betterdoctor.com/data-models#Specialty_List
    end
  end

  def self.insurances
    @insurances ||= wrap_api_call("insurances") do |data|
      data ## see https://developer.betterdoctor.com/data-models#InsuranceProvider
    end
  end

  ## TODO Map zipcode to lat/long - although this will probably happen upstream in the caller to .search

  private

  BETTER_DOCTOR_API = {
    api_key: ENV['BETTER_DOCTOR_API_KEY'],
    base_url: "https://api.betterdoctor.com/",
    version: "beta"
  }

  def self.build_query_url(arg_str)
    return if arg_str.blank?

    query_param_suffix = if arg_str =~ /\?/
                           "&"
                         else
                           "?"
                         end

    arg_str += query_param_suffix

    "#{BETTER_DOCTOR_API[:base_url]}#{BETTER_DOCTOR_API[:version]}/#{arg_str}user_key=#{BETTER_DOCTOR_API[:api_key]}"
  end
  private_class_method :build_query_url

  ## TODO See API for payload fields - https://developer.betterdoctor.com/documentation
  def self.parse_doctor_response(doctor_response)
    { profile: doctor_response["profile"],
      ratings: doctor_response["ratings"].map{|r| r["rating"]},
      image_url: doctor_response["profile"]["image_url"]
    }
  end
  private_class_method :parse_doctor_response

  def self.default_search_opts
    { user_location: { lat: "37.773", lon: "-122.413" },
      distance: 10,
      gender: "female",
      specialty_uid: "vascular-surgeon",
      insurance_uid: "wellmark-allianceselectiowa"
    }
  end
  private_class_method :default_search_opts

  ## Search by the following fields: (see https://developer.betterdoctor.com/documentation for more)
  ## - gender - "string"
  ## - specialty_uid - "string" (see .specialties)
  ## - insurance_uid - "string" (see .insurances for uids of plans, not companies)
  ## - user_location - {lat: "-?###.###", lon: "-?###.###" }
  ## - distance - ## (miles)
  def self.build_search_query(opts)
    q = ""
    ## Params that can be included w/o transformation
    [:gender, :specialty_uid, :insurance_uid].each do |k|
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
  private_class_method :build_search_query

  def self.wrap_api_call(query_str)
    response = HTTParty.get(build_query_url(query_str))

    if response.success?
      yield response["data"]
    else
      response_metadata = response["meta"]
      { error: response_metadata["message"], error_code: response_metadata["error_code"]}
    end
  end
  private_class_method :wrap_api_call
end
