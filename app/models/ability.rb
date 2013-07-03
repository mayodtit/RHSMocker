class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    can :manage, User do |u|
      user.id == u.id
    end
  end
end
