module PusherModule
  def broadcast pusher_id, type, content_id, content_type
    Pusher[pusher_id].trigger(type, {:content_id => content_id, :content_type => content_type})
  end
end
