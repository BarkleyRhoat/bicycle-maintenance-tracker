class MaintenanceLog < ApplicationRecord
  belongs_to :bike
  belongs_to :component, optional: true

  scope :recent, -> { order(service_date: :desc) }

  validates :service_date, presence: true
  validate :service_date_cannot_be_in_the_future
  validates :description, presence: true
  validates :km_at_service, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :component_must_be_installed_on_bike, if: -> { component_id.present? }

private

  def service_date_cannot_be_in_the_future
    return if service_date.blank?
    return if service_date <= Date.current

    errors.add(:service_date, "cannot be in the future")
  end

  def component_must_be_installed_on_bike
    return if bike.blank?
    return if bike.component_ids.include?(component_id)

    errors.add(:component, "must be installed on this bike")
  end
end
