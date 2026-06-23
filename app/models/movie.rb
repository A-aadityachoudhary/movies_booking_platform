class Movie < ApplicationRecord
    has_many :shows, dependent: :destroy
    has_many :reviews, dependent: :destroy
end
