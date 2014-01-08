class WaitlistEntry < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessible :email

  validates :email, presence: true, uniqueness: true
end
