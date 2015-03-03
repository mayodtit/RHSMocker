require 'net/http'

class PubSub
  class << self
    def publish(channel, data, session_id = nil)
      Spawnling.new do
        message = {
          channel: "/#{Rails.env}#{channel}",
          data: data.merge!({guid: session_id}),
          ext: { secret: PUB_SUB_SECRET}
        }

        uri = URI.parse PUB_SUB_HOST
        Net::HTTP.post_form(uri, message: message.to_json) unless Rails.env.test?
      end
    end
  end
end
