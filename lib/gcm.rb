class GCM
  def self.alert_new_message(gcm_id)
    payload = {
      registration_ids: [gcm_id],
      data: {
        new_message: true # Android client only checks for existence of 'new_message' key.  Value can be anything
      }
    }

    Curl::Easy.http_post(GCM_URL, payload.to_json) do |c|
      c.headers['Content-Type'] = 'application/json'
      c.headers['Authorization'] = "key=#{GCM_KEY}"
    end
  end
end