class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    can :manage, User do |u|
      user.id == u.id || user.associates.find_by_id(u.id)
    end

    can :manage, [BloodPressure, UserDiseaseTreatment, UserAllergy, UserDisease, Weight] do |o|
      (user.id == o.user_id) || (can?(:manage, o.user))
    end
  end
end
