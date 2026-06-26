class Movie < ApplicationRecord
    has_many :shows, dependent: :destroy
    has_many :reviews, dependent: :destroy
    enum :status, {upcoming: 0, active: 1, inactive: 2}, default: :upcoming
end
