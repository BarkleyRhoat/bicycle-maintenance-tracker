class BikeComponent < ApplicationRecord
  belongs_to :bike
  belongs_to :component

  validates :installed_on, presence: true
  validate :installed_on_cannot_be_in_the_future
  validates :current_km, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :component_id, uniqueness: { scope: :bike_id, message: "is already installed on this bike" }

  private

  def installed_on_cannot_be_in_the_future
    return if installed_on.blank?
    return if installed_on <= Date.current

    errors.add(:installed_on, "cannot be in the future")
  end
end
