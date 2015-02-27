require 'mailcheck'
require 'valid_email'
class Api::V1::ValidateEmailController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    t1 = Time.now
    email = params[:q]
    @suggestion = suggest(email)
    @suggestion == false ? @suggestion = {:suggestion => false} : @suggestion[:suggestion] = true
    t2 = Time.now
    puts "sift calculation = #{t2-t1}"
    check_domain(email) ? render_success(@suggestion) : render_failure(@suggestion, 422)
    t3 = Time.now
    puts "check_domain calculation = #{t3-t2}"
    puts "total run time = #{t3-t1}" 
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
