class SubscriptionPlan < ApplicationRecord
    has_many :subscriptions
    has_many :users, through: :subscription
end
