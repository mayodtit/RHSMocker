class UserRequestTaskSerializer < TaskSerializer
  attributes :user_request_id

  def type
    'user-request'
  end
end
