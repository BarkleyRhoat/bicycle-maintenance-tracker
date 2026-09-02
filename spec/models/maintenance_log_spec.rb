require "rails_helper"

RSpec.describe MaintenanceLog, type: :model do
  describe "associations" do
    it "belongs to a bike" do
      maintenance_log = create(:maintenance_log)
      expect(maintenance_log.bike).to be_a(Bike)
    end

    it "optionally belongs to a component" do
      log_without_component = create(:maintenance_log, component: nil)

      expect(log_without_component.component).to be_nil
      expect(log_without_component).to be_valid
    end
  end

  describe "validations" do
    it "is valid with a bike, service_date, description, and non-negative km_at_service" do
      maintenance_log = build(:maintenance_log)
      expect(maintenance_log).to be_valid
    end

    it "is invalid without service_date" do
      maintenance_log = build(:maintenance_log, service_date: nil)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:service_date]).to include("can't be blank")
    end

    it "is invalid with service_date in the future" do
      maintenance_log = build(:maintenance_log, service_date: Date.current + 1.day)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:service_date]).to include("cannot be in the future")
    end

    it "is valid with service_date of today" do
      maintenance_log = build(:maintenance_log, service_date: Date.current)
      expect(maintenance_log).to be_valid
    end

    it "is invalid without a description" do
      maintenance_log = build(:maintenance_log, description: nil)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:description]).to include("can't be blank")
    end

    it "is invalid without km_at_service" do
      maintenance_log = build(:maintenance_log, km_at_service: nil)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:km_at_service]).to include("can't be blank")
    end

    it "is invalid with negative km_at_service" do
      maintenance_log = build(:maintenance_log, km_at_service: -10)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:km_at_service]).to include("must be greater than or equal to 0")
    end

    it "is invalid with non-integer km_at_service" do
      maintenance_log = build(:maintenance_log, km_at_service: 45.5)
      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:km_at_service]).to include("must be an integer")
    end

    it "is valid with a component installed on the bike" do
      bike = create(:bike)
      component = create(:component)
      create(:bike_component, bike: bike, component: component)
      maintenance_log = build(:maintenance_log, bike: bike, component: component)

      expect(maintenance_log).to be_valid
    end

    it "is invalid with a component not installed on the bike" do
      bike = create(:bike)
      component = create(:component)
      maintenance_log = build(:maintenance_log, bike: bike, component: component)

      expect(maintenance_log).not_to be_valid
      expect(maintenance_log.errors[:component]).to include("must be installed on this bike")
    end
  end

  describe "scopes" do
    it "orders logs by most recent service_date with the recent scope" do
      bike = create(:bike)
      old_log = create(:maintenance_log, bike: bike, service_date: 3.months.ago, description: "Old service")
      new_log = create(:maintenance_log, bike: bike, service_date: Date.current, description: "New service")

      expect(bike.maintenance_logs.recent).to eq([new_log, old_log])
    end
  end
end
