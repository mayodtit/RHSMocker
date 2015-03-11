class Api::V1::DomainsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    if valid_domain? 
      suggestion ? render_success(suggestion) : render_success
    else
      invalid_domain_response
    end
  end

  def submit
    if valid_domain? 
      Domain.create!(email_domain: email_domain) if not_in_db? email_domain
      render_success
    else
      invalid_domain_response
    end
  end

  def all_domains
    render_success(domains: domains)
  end

  def suggest
    render_success(domains: domains.select {|d| d.starts_with?(email_domain)})
  end

  private

  def not_in_db? (domain)
    Domain.where(email_domain: domain).none?
  end

  def invalid_domain_response
    suggestion ? render_failure(suggestion, 422) : render_failure({reason: 'Invalid email domain, no suggestions found'}, 422)
  end

  def suggestion
    @suggestion ||= Mailcheck2.new(
      :domains => domains,
      :top_level_domains => MAILCHECK_TOP_LEVEL_DOMAINS
    ).suggest(params[:email])
  end

  def valid_domain?
    ValidateEmail.valid?(params[:email]) && ValidateEmail.mx_valid?(params[:email])
  end

  def email_domain
    @email_domain ||= params[:email].split('@').last
  end

  def domains
    @domains ||= Domain.find(:all).flat_map(&:email_domain).sort
  end
end
