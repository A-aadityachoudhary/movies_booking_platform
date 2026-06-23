# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Movie  
    can :read, Show
    can :read, Theater
    can :read, Screen
    can :read, Seat
    can :read, Review

    return unless user.present?
    if user.customer?
      can :create, [Booking, SeatLock, Review]
      can [:read, :update, :destroy], [Booking, SeatLock, Review]
    end
    if user.theater_owner?
      can :manage, [Theater, Screen, Seat, Show, Subscription]
      can :read, [Booking, Payment]
    end
    if user.admin?
      can :manage, :all
    end
  end
end
