class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # support for not logged-in user

    alias_action :read, :update, to: :ru
    alias_action :create, :read, :update, to: :cru

    can :manage, User do |u|
      if user.id == u.id || user.associates.find_by_id(u.id)
        true
      else
        can_manage = false
        user.associates.each do |a|
          if a.associates.find_by_id(u.id)
            can_manage = true
            break
          end
        end
        can_manage
      end
    end

    can :manage, Association do |a|
      user.associations.include?(a) ||
      user.inverse_associations.include?(a) ||
      can?(:manage, a.user)
    end

    can :read, Permission do |p|
      user.id == p.subject.user_id
    end

    can :manage, Permission do |p|
      user.id == p.subject.associate_id || user.id == p.subject.associate.owner_id
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
      can :ru, Task do |o|
        o.for_nurse? || o.owner_id == o.id
      end

      can :ru, PhoneCall do |o|
        o.to_nurse?
      end
    end

    if user.pha?
      can :manage, User
      can :manage, Member

      can :cru, Task do |o|
        o.for_pha? || o.owner_id == o.id
      end

      can :ru, PhoneCall do |o|
        o.to_pha?
      end

      can :hang_up, PhoneCall do |o|
        o.to_pha?
      end

      can :ru, ScheduledPhoneCall do |o|
        o.owner.id == user.id
      end

      can :index, ScheduledPhoneCall
      can :read, Role
    end

    if user.pha_lead?
      can :manage, ScheduledPhoneCall
    end

    if user.care_provider?
      can :manage, Consult
      can :ru, Member
      can :index, Message
    end
  end
end
