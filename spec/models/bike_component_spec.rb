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

    it "is invalid with installed_on in the future" do
      bike_component = build(:bike_component, installed_on: Date.current + 1.day)
      expect(bike_component).not_to be_valid
      expect(bike_component.errors[:installed_on]).to include("cannot be in the future")
    end

    it "is valid with installed_on of today" do
      bike_component = build(:bike_component, installed_on: Date.current)
      expect(bike_component).to be_valid
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

    it "is invalid when the component is already installed on another bike" do
      bike1 = create(:bike)
      bike2 = create(:bike, user: bike1.user)
      component = create(:component, user: bike1.user)
      create(:bike_component, bike: bike1, component: component)
    
      duplicate = build(:bike_component, bike: bike2, component: component)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:component_id]).to include("is already installed on a bike")
    end
  end
end
