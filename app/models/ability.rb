class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    alias_action :read, :update, :to => :ru

    can :manage, User do |u|
      user.id == u.id || user.associates.find_by_id(u.id)
    end

    can :manage, [BloodPressure, UserTreatment, UserAllergy, UserCondition, Weight, Card, Subscription] do |o|
      (user.id == o.user_id) || (can?(:manage, o.user))
    end

    can :manage, Consult do |o|
      o.users.include?(user)
    end

    can :manage, PhoneCallSummary do |pcs|
      pcs.message.consult.users.include?(user)
    end

    if user.try_method(:hcp?)
      can :manage, :all
    end

    if user.admin?
      can :assign_roles, User
    end

    if user.hcp?
      can :ru, PhoneCall
    end
  end
end
