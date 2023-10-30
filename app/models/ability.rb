# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
  can :read, Blog, visible: true
  return if user.blank?
    can :read, Blog
    can :update, Blog, { user: }
    can :read, Blog, { user: }
    can %i[update destroy], Blog, { user: }
    can %i[update destroy],Subscription,{user:}
    can :create,Blog,{user:}
  end
end
