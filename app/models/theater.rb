class Theater < ApplicationRecord
  belongs_to :user
  has_many :screens, dependent: :destroy
  has_many :shows, through: :screens
end
