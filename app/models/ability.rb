class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    alias_action :read, :update, :to => :ru

    can :manage, User do |u|
      user.id == u.id || user.associates.find_by_id(u.id)
    end

    can :manage, Association do |a|
      user.associations.include?(a)
    end

    can :manage, [BloodPressure, UserTreatment, UserAllergy, UserCondition, Weight, Card, Subscription] do |o|
      (user.id == o.user_id) || (can?(:manage, o.user))
    end

    can :manage, Consult do |o|
      o.initiator_id == user.id
    end

    can :manage, PhoneCallSummary do |o|
      (o.message && o.message.consult && can?(:manage, o.message.consult))
    end

    can :ru, ScheduledPhoneCall do |o|
      (o.state == 'assigned' && o.scheduled_at > Time.now) ||
      o.user_id == user.id ||
      (o.message && o.message.consult && can?(:manage, o.message.consult))
    end

    cannot :manage, Program
    cannot :manage, CustomCard
    cannot :index, Member

    if user.admin?
      can :manage, :all
      can :assign_roles, User
    end

    if user.nurse?
      can :ru, PhoneCall do |o|
        o.to_nurse?
      end
    end

    if user.pha? || user.pha_lead?
      can :manage, User

      can :ru, PhoneCall do |o|
        o.to_pha?
      end

      can :ru, ScheduledPhoneCall do |o|
        o.owner.id == user.id
      end
    end

    if user.pha_lead?
      can :manage, ScheduledPhoneCall
      can :read, Role
    end
  end
end
