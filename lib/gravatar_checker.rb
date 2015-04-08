require 'gravtastic'
require 'httparty'
class GravatarChecker
  include Gravtastic
  include HTTParty

  def initialize(email)
    @email = email
  end

  gravtastic  :secure => true,
              :size => 240

  def check_gravatar
    HTTParty.get(gravatar_url :default => 404).code != 404 ? gravatar_url : nil
  end

  def email
    @email
  end
end
