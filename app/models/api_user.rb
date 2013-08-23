class ApiUser < ActiveRecord::Base
  include SoftDeleteModule

  has_many :nurseline_records

  attr_accessible :name, :auth_token

  validates :name, presence: true

  before_create :generate_auth_token
  before_destroy :reset_auth_token

  def generate_auth_token
    self.auth_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  def reset_auth_token
    self.auth_token = nil
  end
end
