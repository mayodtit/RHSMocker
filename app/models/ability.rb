class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user
  end
end
