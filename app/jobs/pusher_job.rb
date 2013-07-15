require 'pusher_module'
include PusherModule

class PusherJob
  def push_content(user_id)
    user = User.find(user_id)
    return if user.hasMaxContent
    content = Content.getRandomContent
    user.user_readings.create(content: content)
    PusherModule.broadcast(user.id, 'newcontent', content.id, content.contentsType)
  end
  handle_asynchronously :push_content
end
