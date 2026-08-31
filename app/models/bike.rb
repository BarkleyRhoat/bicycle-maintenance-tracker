class Bike < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :brand, presence: true
end
