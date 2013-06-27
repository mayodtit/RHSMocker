class ErrorsController < ActionController::Base
  def exception
    @exception = env["action_dispatch.exception"]
    @wrapper = ActionDispatch::ExceptionWrapper.new(env, @exception)
    @json = {:status => :failure,
             :user_message => '',
             :reason => @exception.to_s}
    @json.merge!({:backtrace => @exception.backtrace}) unless Rails.env.production?
    render :json => @json, :status => @wrapper.status_code
  end
end
