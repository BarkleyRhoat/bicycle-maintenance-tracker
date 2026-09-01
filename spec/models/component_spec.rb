require "rails_helper"

RSpec.describe Component, type: :model do
  describe "associations" do
    it "has many bikes through bike_components" do
      component = create(:component)
      bike1 = create(:bike, name: "Road Bike")
      bike2 = create(:bike, name: "Gravel Bike")
      create(:bike_component, bike: bike1, component: component)
      create(:bike_component, bike: bike2, component: component)

      expect(component.bikes).to include(bike1, bike2)
    end
  end

  describe "validations" do
    it "is valid with a name, component_type, and positive expected_lifespan_km" do
      component = build(:component)
      expect(component).to be_valid
    end

    it "is valid without an expected_lifespan_km (indefinite lifespan)" do
      component = build(:component, expected_lifespan_km: nil)
      expect(component).to be_valid
    end

    it "is invalid without a name" do
      component = build(:component, name: nil)
      expect(component).not_to be_valid
      expect(component.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a component_type" do
      component = build(:component, component_type: nil)
      expect(component).not_to be_valid
      expect(component.errors[:component_type]).to include("can't be blank")
    end

    it "is invalid with a non-positive expected_lifespan_km" do
      component = build(:component, expected_lifespan_km: 0)
      expect(component).not_to be_valid
      expect(component.errors[:expected_lifespan_km]).to include("must be greater than 0")
    end

    it "is invalid with a non-integer expected_lifespan_km" do
      component = build(:component, expected_lifespan_km: 1250.5)
      expect(component).not_to be_valid
      expect(component.errors[:expected_lifespan_km]).to include("must be an integer")
    end
  end
end
