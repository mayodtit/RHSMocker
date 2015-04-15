MAILCHECK_DOMAINS.each do |domain|
  Domain.find_or_create_by_email_domain(email_domain: domain)
end