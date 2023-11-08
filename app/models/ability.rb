# frozen_string_literal: true

# class Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Blog, visible: true
    return if user.blank?

    # can :read, Plan, visible: true
    can :read, Plan
    can [:index], Plan
    can :read, Blog
    can %i[update destroy], Blog, { user: }
    can %i[update destroy], Subscription, { user: }
    can :create, Blog, { user: }
    can :create, Subscription, { user: }
    can :read, Subscription, user_id: user.id
    can :blog_read, Blog
    can :manage, Blog, { user: }
    can :manage, Subscription, { user: }
  end
end
