class ErrorsController < ActionController::Base
  def exception
    @exception = env["action_dispatch.exception"]
    @wrapper = ActionDispatch::ExceptionWrapper.new(env, @exception)
    render :json => {:status => :failure,
                     :user_message => "",
                     :reason => @exception.to_s}.to_json,
           :status => @wrapper.status_code
  end
end
