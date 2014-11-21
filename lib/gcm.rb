class GCM
  def self.alert_new_message(gcm_id)
    payload = {
      registration_ids: [gcm_id],
      data: {
        new_message: true # Android client only checks for existence of 'new_message' key.  Value can be anything
      }
    }

    uri = URI(GCM_URL)
    req = Net::HTTP::Post.new(uri)
    req.body = payload.to_json
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "key=#{GCM_KEY}"
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    http.request(req) do |response|
      # use the response to ensure we block until the response is received
      Rails.logger.info("GCM alert completed: #{response.to_s}")
    end
  end
end
