class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    can :manage, User do |u|
      user.id == u.id || user.associates.find_by_id(u.id)
    end

    can :manage, [BloodPressure, UserDiseaseTreatment, UserAllergy, UserDisease, Weight, Card] do |o|
      (user.id == o.user_id) || (can?(:manage, o.user))
    end

    can :manage, Encounter do |o|
      o.users.include?(user)
    end

    # hack until User/Member model is refactored
    can :manage, User

    if user.hcp?
      can :manage, :all
    end
  end
end
