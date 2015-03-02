class Api::V1::ValidateEmailController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    if suggestion
      valid_domain? ? render_success(suggestion) : render_failure(suggestion, 422)
    else
      valid_domain? ? render_success() : render_failure({reason: 'Invalid email domain, no suggestions found'}, 422)
    end
  end

  private

  def suggestion
    @suggestion = Mailcheck2.new(
      :domains => MAILCHECK_DOMAINS,
      :top_level_domains => MAILCHECK_TOP_LEVEL_DOMAINS
    ).suggest(params[:email])
  end

  def valid_domain?
    ValidateEmail.valid?(params[:email]) && ValidateEmail.mx_valid?(params[:email])
  end
end
