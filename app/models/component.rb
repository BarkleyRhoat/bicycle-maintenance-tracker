class Component < ApplicationRecord
  has_many :bike_components, dependent: :destroy
  has_many :bikes, through: :bike_components

  validates :name, presence: true
  validates :component_type, presence: true
  validates :expected_lifespan_km, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
