class User < ApplicationRecord
    has_many :subscriptions, dependent: :destroy
    has_many :subscription_plans, through: :subscriptions
    has_many :theaters, dependent: :destroy
    has_many :bookings, dependent: :destroy
    has_many :seat_locks, dependent: :destroy
    has_many :reviews, dependent: :destroy
end
