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

    can :manage, [ScheduledPhoneCall, PhoneCallSummary] do |o|
      can? :manage, o.message.consult
    end

    cannot :manage, Program
    cannot :manage, CustomCard
    cannot :index, Member

    if user.try_method(:nurse?) || user.try_method(:admin?)
      can :manage, :all
    end

    if user.admin?
      can :assign_roles, User
    end

    if user.nurse?
      can :ru, PhoneCall
    end
  end
end
