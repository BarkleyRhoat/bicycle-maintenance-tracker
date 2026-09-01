class BikeComponent < ApplicationRecord
  belongs_to :bike
  belongs_to :component

  validates :installed_on, presence: true
  validates :current_km, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :component_id, uniqueness: { scope: :bike_id, message: "is already installed on this bike" }
end
