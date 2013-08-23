class NurselineRecord < ActiveRecord::Base
  belongs_to :api_user

  attr_accessible :api_user, :api_user_id, :payload

  validates :api_user, :payload, presence: true
end
