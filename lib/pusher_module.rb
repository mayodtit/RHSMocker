module PusherModule
  def broadcast user_id, type, content_id, content_type
    Pusher['RHS_'+user_id].trigger(type, {:content_id => content_id, :content_type => content_type})
  end
end