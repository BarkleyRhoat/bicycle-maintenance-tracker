require "rails_helper"

RSpec.describe BikeComponent, type: :model do
  describe "associations" do
    it "belongs to a bike" do
      bike_component = create(:bike_component)
      expect(bike_component.bike).to be_a(Bike)
    end

    it "belongs to a component" do
      bike_component = create(:bike_component)
      expect(bike_component.component).to be_a(Component)
    end
  end

  describe "validations" do
    it "is valid with a bike, component, installed_on date, and non-negative current_km" do
      bike_component = build(:bike_component)
      expect(bike_component).to be_valid
    end

    it "is invalid without installed_on" do
      bike_component = build(:bike_component, installed_on: nil)
      expect(bike_component).not_to be_valid
      expect(bike_component.errors[:installed_on]).to include("can't be blank")
    end

    it "is invalid without current_km" do
      bike_component = build(:bike_component, current_km: nil)
      expect(bike_component).not_to be_valid
      expect(bike_component.errors[:current_km]).to include("can't be blank")
    end

    it "is invalid with negative current_km" do
      bike_component = build(:bike_component, current_km: -5)
      expect(bike_component).not_to be_valid
      expect(bike_component.errors[:current_km]).to include("must be greater than or equal to 0")
    end

    it "is invalid with non-integer current_km" do
      bike_component = build(:bike_component, current_km: 12.5)
      expect(bike_component).not_to be_valid
      expect(bike_component.errors[:current_km]).to include("must be an integer")
    end

    it "prevents duplicate component installation on the same bike" do
      bike = create(:bike)
      component = create(:component)
      create(:bike_component, bike: bike, component: component)

      duplicate = build(:bike_component, bike: bike, component: component)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:component_id]).to include("is already installed on this bike")
    end
  end
end
