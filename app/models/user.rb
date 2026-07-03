class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :subscriptions, dependent: :destroy
    has_many :subscription_plans, through: :subscriptions
    has_many :theaters, dependent: :destroy
    has_many :bookings, dependent: :destroy
    has_many :seat_locks, dependent: :destroy
    has_many :reviews, dependent: :destroy
    enum :role, {customer: 0, theater_owner: 1, admin: 2}, default: :customer
    validates :role, presence: true
end
