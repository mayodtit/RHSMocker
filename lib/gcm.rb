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
    req.set_form_data(payload)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "key=#{GCM_KEY}"
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
