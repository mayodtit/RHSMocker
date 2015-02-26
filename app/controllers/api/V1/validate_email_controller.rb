require 'mailcheck'
require 'valid_email'
class Api::V1::ValidateEmailController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    email = params[:q]
    @suggestion = suggest(email)
    if @suggestion == false
      @suggestion = {:suggestion => false}
    end
    if check_domain(email)
      render_success(@suggestion)
    else
      render_failure(@suggestion, 422)
    end  
  end

  def suggest(email)
    mailcheck = Mailcheck.new(
      :domains => MAILCHECK_DOMAINS,
      :top_level_domains => MAILCHECK_TOP_LEVEL_DOMAINS
    )
    mailcheck.suggest(email)
  end

  def check_domain(email) 
    puts email
    puts "ValidateEmail.valid?(#{email}) = #{ValidateEmail.valid?(email)}"
    puts "ValidateEmail.mx_valid?(#{email}) = #{ValidateEmail.mx_valid?(email)}"
    ValidateEmail.valid?(email) && ValidateEmail.mx_valid?(email)
  end
end
