require 'valid_email'
class Api::V1::ValidateEmailController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    email = params[:email]
    @suggestion = suggest(email)
    if @suggestion == false 
      check_domain(email) ? render_success() : render_failure({reason: 'Invalid email domain, no suggestions found'}, 422)
    else
      check_domain(email) ? render_success(@suggestion) : render_failure(@suggestion, 422)
    end
  end

  private

  def suggest(email)
    mailcheck = Mailcheck2.new(
      :domains => MAILCHECK_DOMAINS,
      :top_level_domains => MAILCHECK_TOP_LEVEL_DOMAINS
    )
    mailcheck.suggest(email)
  end

  def check_domain(email) 
    ValidateEmail.valid?(email) && ValidateEmail.mx_valid?(email)
  end
end
