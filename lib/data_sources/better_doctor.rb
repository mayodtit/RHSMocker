class DataSources::BetterDoctor
  include HTTParty

  ## TODO Store in config, environment, ??
  BETTER_DOCTOR_API = {
    api_key: "edd4c37c129961549d4f1882251b261c",
    base_url: "https://api.betterdoctor.com/",
    version: "beta"
    ## TODO Our key doesn't work for the "2015-01-27" version of the API
  }

  def self.build_query_str(arg_str)
    return if arg_str.empty?

    query_param_suffix = if arg_str =~ /\?/
                           "&"
                         else
                           "?"
                         end

    arg_str += query_param_suffix

    BETTER_DOCTOR_API[:base_url] +
      BETTER_DOCTOR_API[:version] + "/" +
      arg_str +
      "user_key=" + BETTER_DOCTOR_API[:api_key]
  end

  def self.lookup_by_npi(npi)
    npi_query_section = "doctors/npi/#{npi}"
    query_url = build_query_str(npi_query_section)

    response = HTTParty.get(query_url)

    if response.success?
      ## TODO See API for payload fields - https://developer.betterdoctor.com/documentation
      data = response["data"]
      { profile: data["profile"],
        ratings: data["ratings"].map{|r| r["rating"]},
        image_url: data["profile"]["image_url"]
      }
    else
      response_metadata = response["meta"]
      { error: response_metadata["message"], error_code: response_metadata["error_code"]}
    end
  end
end
