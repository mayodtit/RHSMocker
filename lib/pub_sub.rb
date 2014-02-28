require 'net/http'

class PubSub
  class << self
    def publish(channel, data)
      return unless Metadata.find_by_mkey('use_pub_sub').try(:mvalue) == 'true'
      message = {
        channel: "/#{Rails.env}#{channel}",
        data: data,
        ext: { secret: PUB_SUB_SECRET }
      }

      uri = URI.parse PUB_SUB_HOST
      Net::HTTP.post_form(uri, message: message.to_json)
    end
    handle_asynchronously :publish
  end
end
