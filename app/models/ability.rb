class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :hcp
      can :manage, Message
    end
  end
end
