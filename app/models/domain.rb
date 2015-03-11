class Domain < ActiveRecord::Base
  attr_accessible :email_domain
  validates :email_domain, presence: true, uniqueness: true
end
