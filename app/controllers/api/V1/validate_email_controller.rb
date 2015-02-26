require 'mailcheck'

class Api::V1::ValidateEmailController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    @suggestion = validate(params[:q])
    if @suggestion == false
      render_success
    else    
      render_failure(@suggestion, 422)
    end
  end

  def validate(email)
    mailcheck = Mailcheck.new
    mailcheck.suggest(email)
  end
end
