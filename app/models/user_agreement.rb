class UserAgreement < ActiveRecord::Base
  belongs_to :user
  belongs_to :agreement

  attr_accessible :user, :user_id, :agreement, :agreement_id, :user_agent,
                  :ip_address

  validates :user, :agreement, :user_agent, :ip_address, presence: true
  validates :agreement_id, :uniqueness => {:scope => :user_id}
end
