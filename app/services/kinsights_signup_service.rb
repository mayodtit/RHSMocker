class KinsightsSignupService < Struct.new(:user, :token)
  def call
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body, symbolize_names: true)
      user.update_attributes!(kinsights_patient_url: body[:patient_url],
                              kinsights_profile_url: body[:profile_url])
      NewKinsightsMemberTask.create(member: user.owner,
                                    subject: user)
    end
  end

  private

  def uri
    @uri ||= URI("https://kinsights.com/records/careteam/delegate/#{token}/accept/")
  end

  def request
    @request ||= Net::HTTP::Get.new(uri)
  end
end
