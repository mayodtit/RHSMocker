class Domain < ActiveRecord::Base
  attr_accessible :email_domain
  validates :email_domain, presence: true, uniqueness: true

  def self.seed_domains
    MAILCHECK_DOMAINS.each{ |domain| Domain.find_or_create_by_email_domain(email_domain: domain) }
  end
end
