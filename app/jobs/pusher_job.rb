require 'pusher_module'
include PusherModule

class PusherJob
  def push_content(user_id)
    user = Member.find(user_id)
    return if user.max_inbox_content?
    content = Content.next_for(user)
    return unless content
    user.cards.create(resource: content)
    PusherModule.broadcast(user.pusher_id, 'newcontent', content.id, content.content_type)
  end
  handle_asynchronously :push_content
end
