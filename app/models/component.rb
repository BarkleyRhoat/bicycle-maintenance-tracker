class Component < ApplicationRecord
  validates :name, presence: true
  validates :component_type, presence: true
  validates :expected_lifespan_km, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
