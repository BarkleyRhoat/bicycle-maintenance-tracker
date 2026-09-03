class BikeComponent < ApplicationRecord
  belongs_to :bike
  belongs_to :component

  validates :installed_on, presence: true
  validate :installed_on_cannot_be_in_the_future
  validates :current_km, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :component_id, uniqueness: { message: "is already installed on a bike" }
  validate :component_must_belong_to_bike_owner

private

  def installed_on_cannot_be_in_the_future
    return if installed_on.blank?
    return if installed_on <= Date.current

    errors.add(:installed_on, "cannot be in the future")
  end

  def component_must_belong_to_bike_owner
    return if component.blank? || bike.blank?
    return if component.user_id == bike.user_id

    errors.add(:component, "must belong to the bike owner")
  end
end
