require 'net/http'

class PubSub
  class << self
    def publish(channel, data)
      Spawnling.new do
        message = {
          channel: "/#{Rails.env}#{channel}",
          data: data,
          ext: { secret: PUB_SUB_SECRET }
        }

        uri = URI.parse PUB_SUB_HOST
        Net::HTTP.post_form(uri, message: message.to_json)
      end
    end
  end
end
