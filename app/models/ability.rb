class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    can :manage, User do |u|
      user.id == u.id || user.associates.find_by_id(u.id)
    end

    can :manage, BloodPressure do |bp|
      (user.id == bp.user_id) || (can?(:manage, bp.user))
    end
  end
end
