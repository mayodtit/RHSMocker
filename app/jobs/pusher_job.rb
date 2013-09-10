require 'pusher_module'
include PusherModule

class PusherJob
  def push_content(user_id)
    user = Member.find(user_id)
    return if user.hasMaxContent
    content = user.getContent
    return unless content
    user.user_readings.create(content: content)
    PusherModule.broadcast(user.pusher_id, 'newcontent', content.id, content.content_type)
  end
  handle_asynchronously :push_content

  def push_status(user_id, user_reading_id, status)
    user = Member.find(user_id)
    user_reading = user.user_readings.find(user_reading_id)
    PusherModule.broadcast(user.pusher_id, status, user_reading.content_id, user_reading.content.content_type)
  end
  handle_asynchronously :push_status
end
